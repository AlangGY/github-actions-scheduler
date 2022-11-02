
pullRequests="$(gh api graphql -F owner=AlangGY -F name=github-actions-scheduler -f query='
            query($name: String!, $owner: String!) {
              repository(owner: $owner, name: $name) {
                pullRequests(last:100) {  nodes { number , labels(last: 20) { nodes { name } }  } }
              }
            }
          ' --jq '[(.data.repository.pullRequests.nodes.[] | "@", .number , .labels.nodes[].name)] | join("_")')"

for pr in $(echo $pullRequests | sed 's/_@_/\n/g' | sed 's/@_/\n/g'); do
  prNumber=$(echo $pr | cut -d'_' -f1)
  prLabels=$(echo $pr | cut -d'_' -f2-)
  for label in $(echo $prLabels | sed 's/_/\n/g'); do
    if [[ $label =~ ["^(D-)"] ]]; then
        if [[ $label == "D-0" ]]; then
            nextLabel="expired"
        else
            nextLabel="D"-$((${label:2} - 1))
        fi
        echo "change prNumber:" $prNumber "'s label from" $label "to" $nextLabel
        echo $(gh pr edit $prNumber --remove-label $label --add-label $nextLabel)
    fi
  done
done
