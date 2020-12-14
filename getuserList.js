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
