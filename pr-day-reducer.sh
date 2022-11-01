
pullRequests="$(gh api graphql -F owner=AlangGY -F name=github-actions-scheduler -f query='
            query($name: String!, $owner: String!) {
              repository(owner: $owner, name: $name) {
                pullRequests(last:100) {  nodes { number, title, labels(last: 20) { nodes { name } }  } }
              }
            }
          ' --jq '.data.repository.pullRequests.nodes')"

echo $pullRequests

for pr in $(echo $pullRequests | jq -r '.[] | @base64'); do
    _jq() {
        echo ${pr} | base64 --decode | jq -r ${1}
    }

    number=$(_jq '.number')
    title=$(_jq '.title')
    labels=$(_jq '.labels.nodes')
    for label in $(echo $labels | jq -r '.[] | @base64'); do
        _jq() {
            echo ${label} | base64 --decode | jq -r ${1}
        }
        label=$(_jq '.name')
        echo $label
        if [[ $label =~ ["^D."] ]]; then
            echo "id: $number, title: $title, label: $label"
            if [[ $label == "D-0" ]]; then
                nextLabel="expired"
            else
                nextLabel="D"-$((${label:2} - 1))
            fi
            $(gh pr edit $number --remove-label $label --add-label $nextLabel)
            echo $label '->' $nextLabel
        fi
    done    
done
