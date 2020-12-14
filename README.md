# Send message to Enterprise WeChat

### All envionment variables

- WEWORK_TOUSER = amy|jack
- WEWORK_CONTENT = "you have a new message..."
- WEWORK_AGENTID = 1000001
- WEWORK_APPSECRET = tTdO5Nn9IBG4iPxxxxxxw0nUTyDF_OrXsUwwbogY
- WEWORK_CORPID = ww1efaxxxxxxxb24df
- WEWORK_USERLIST = [{"name":"amy","userid":"32ee8a9a5d9c6bd2b15c8cf2cba7ba01"},{"name":"jack","userid":"c9ab9a30645f85e07c3f176d21b6c220"}]



### How to get enterprise wechat userlist

- Due to the limit of obtaining token times, we must get user list before use this action, run script `export WEWORK_CORPID=xxx && export WEWORK_APPSECRET=xxxx && node ./getuserList.js`

### Used for Github Actions
``` yaml
name: ci
on:
  push:
    branches: master
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      -
        name: test send message
        uses: ntfs32/wework@v0.1.0-alpha
        with:
          WEWORK_USERLIST: ${{ secrets.WEWORK_USERLIST }}
          WEWORK_CORPID: ${{ secrets.WEWORK_CORPID }}
          WEWORK_AGENTID: ${{ secrets.WEWORK_AGENTID }}
          WEWORK_APPSECRET: ${{ secrets.WEWORK_APPSECRET }}
          WEWORK_TOUSER: "shaddock"
          WEWORK_CONTENT: "thsi is a test"

```

### Used for Gitlab Ci

1.  update gitlab group CI / CD Settings -> Variables
     - WEWORK_AGENTID = 1000001
     - WEWORK_APPSECRET = tTdO5Nn9IBG4iPxxxxxxw0nUTyDF_OrXsUwwbogY
     - WEWORK_CORPID = ww1efaxxxxxxxb24df
     - WEWORK_USERLIST = [{"name":"amy","userid":"32ee8a9a5d9c6bd2b15c8cf2cba7ba01"},{"name":"jack","userid":"c9ab9a30645f85e07c3f176d21b6c220"}]

2. update `gitlab-ci.yml`

``` yaml
deploy_notices:
  image:
    name: notices/wework:2.0
  stage:deploy
  only:
    - tags
  script:
    - export WEWORK_TOUSER="amy|jack
    - export WEWORK_CONTENT="$CI_PROJECT_NAME release sunccess, docker image: $IMAGE_NAME:$CI_COMMIT_TAG"
    - /opt/wework.sh

```
