# github actions D-Day scheduler

## 개요

### 배경
- 회사에서 PR을 올릴때, merge 기한을 명시하기 위해 'D-{num}' 형태의 label을 붙이고 있음. 
- D-{num}의 기준은 PR 생성일을 기준으로 함. (이때, 주말과 같은 공휴일을 제외하지 않는다.)

### 문제
- 코드리뷰어는 PR을 확인할때, **리뷰 마감일**을 확인하기 위해 PR의 생성일(createdAt)을 매번 확인하여 계산해야 하는 번거로움.
- 그렇다고해서 PR 작성자가 매일마다 D-{num}을 갱신해주는 일은 더더욱이 번거로움.

### 요구 사항
PR의 D-{num}을 매일마다 '오늘'을 기준으로 갱신해줬으면 좋겠다.


## 그래서 나온... Github Actions: D-Day scheduler

### 시연

| 작동 전 | 
| ----- | 
| ![image](https://user-images.githubusercontent.com/75013334/199412133-8af3c42c-7ab6-4263-b42e-5115321dabef.png) |

| 작동 후 |
| ----- |
|![image](https://user-images.githubusercontent.com/75013334/199412266-621b165c-d747-49ce-b2b2-fea29117dca2.png) |

### 동작방식
- 한국시간 기준(UTC+9) 00:00시에, open 상태의 'D-{num}' 태그를 가진 PR들에 대해서 'D-{num}' -> 'D-{num-1}'로 교체해준다.
- D-0에 대해서는, expired로 변경한다.

### 적용방법
- (!important)해당 레포지토리의 expired, D-{num}(D-0,D-1,D-2...) 라벨을 생성해둔다.
- [pr-day-reducer.yaml](./.github/workflows/pr-day-reducer.yaml) 파일을 적용할 레포지토리 main브랜치의 `.github/workflows/`에 Copy&Paste



