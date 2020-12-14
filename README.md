# Send message to Enterprise WeChat

### All envionment variables

- WEWORK_TOUSER = amy|jack
- WEWORK_CONTENT = "you have a new message..."
- WEWORK_AGENTID = 1000001
- WEWORK_APPSECRET = xxxxx
- WEWORK_CORPID = xxxx
- WEWORK_USERLIST = [{"name":"amy","userid":"32ee8a9a5d9c6bd2b15c8cf2cba7ba01"},{"name":"jack","userid":"c9ab9a30645f85e07c3f176d21b6c220"}]



### How to get enterprise wechat userlist
 - example javascript

```javascript
const axios = require('axios');

const corpId = 'xxxx';
const corpSecret = 'xxxx';
const agentId = '10000001'

async function getAccessToken(corpid, corpsecret) {
    return axios.get(`https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}`).then(res => res.data.access_token).catch(err => {
        console.log('get access_tokentoken failed');
        return '';
    })
}

async function getDepartmentList(accessToken) {
    return axios.get(`https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token=${accessToken}`).then(res => res.data.department).catch(err => {
        console.log('get departmentList failed');
        return [];
    })
}

async function getUserlist(accessToken, departmentId, getchild = true) {
    return axios.get(`https://qyapi.weixin.qq.com/cgi-bin/user/list?access_token=${accessToken}&department_id=${departmentId}&fetch_child=${getchild}`).then(res => {
        return res.data.userlist;
    }).catch(err => {
        console.log('get departmentList  failed');
        return [];
    })
}

// get department List
(async function() {
    const accessToken = await getAccessToken(corpId, corpSecret);
    const departmentList = await getDepartmentList(accessToken);
    let userList = [];
    for (let dep in departmentList) {
        userList.push(...await getUserlist(accessToken, departmentList[dep].id))
    }
    console.log(userList.map(item => {
        return {
            name: item.name,
            userid: item.userid,
        }
    }))
})();

```

### Used for Github Actions
```
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
     - WEWORK_APPSECRET = xxxxx
     - WEWORK_CORPID = xxxx
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
