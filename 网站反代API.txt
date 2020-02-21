addEventListener('fetch', event => {
    event.respondWith(handleRequest(event))
})
  
const GATEWAY_URL = `http://91porn.com`

function GetRandomNum(Min,Max)
{   
    var Range = Max - Min;   
    var Rand = Math.random();   
    return(Min + Math.round(Rand * Range));   
} 

function makeHeader(){
    var num1 = GetRandomNum(1,254);
    var num2 = GetRandomNum(1,254);
    var num3 = GetRandomNum(1,254);
    var num4 = GetRandomNum(1,254);
    var fakeip = num1+'.'+num2+'.'+num3+'.'+num4;    
    var fakeurl = 'http://91porn.com/v.php?next=watch&';
    return {
        headers:{
            'Accept-Language':'zh-CN,zh;q=0.9',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36',
            'X-Forwarded-For': fakeip,
            'referer': fakeurl,
            'Content-Type': 'multipart/form-data; session_language=cn_CN'
        }
    }
}

async function serveApi(event) {
    const url = new URL(event.request.url)
    const cache = caches.default
    let response = await cache.match(event.request)

    
    var expires = new Date();
    expires.setTime(expires.getTime() + 8640000 * 1000);

    if(url.pathname == '\/'){
        var myHeaders = { 'Content-Type': 'text/html','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
        var init = {"status":200, "statusText":"ok", headers: myHeaders};
        response = new Response('This is a simple 91porn API service.', init)
        return response
    }
    

    if(url.pathname == '\/getHot'){
        let params = url.searchParams;
        let page = parseInt(params.get("page"));
        if(page > 3){
          var myHeaders = { 'Content-Type': 'application/json','Access-Control-Allow-Origin':'*','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
          var init = {"status":200, "statusText":"ok", headers: myHeaders};
          response = new Response('{"status":"done"}', init)
          return response
        }

        var fakeheader = makeHeader();
        response = await fetch(`${GATEWAY_URL}/v.php?category=hot&viewtype=basic&page=`+ page,fakeheader)
        var content = await response.text()
        content = content.replace(/[\n\t]/g,"").replace("  ","")
        //console.log(content)
        var items = [];
        var reg = /<div class=\"listchannel\">.*?<a target=blank href=\"(.*?)">                    <img src=\"(.*?)\" width=\"120\" height=\"90\" title=\"(.*?)" \/>                  <\/a>/mg
        while(res = reg.exec(content)){
            res.shift()
            item = {
                url: btoa(res[0]),
                title:res[2],
                img: res[1].replace('http:','https:')
            }
            items.unshift(item);
        }

        var myHeaders = { 'Content-Type': 'application/json','Access-Control-Allow-Origin':'*','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
        var init = {"status":200, "statusText":"ok", headers: myHeaders};        
        response = new Response(JSON.stringify({'items': items.reverse()}), init)
        event.waitUntil(cache.put(event.request, response.clone()))
        return response
    }

    
    if(url.pathname == '\/getNew'){
        let params = url.searchParams;
        let page = parseInt(params.get("page"));

        var fakeheader = makeHeader();
        response = await fetch(`${GATEWAY_URL}/v.php?next=watch&page=`+ page,fakeheader)
        var content = await response.text()
        content = content.replace(/[\n\t]/g,"").replace("  ","")
        //console.log(content)
        var items = [];
        var reg = /<div class=\"listchannel\">.*?<a target=blank href=\"(.*?)">                    <img src=\"(.*?)\" width=\"120\" height=\"90\" title=\"(.*?)" \/>                  <\/a>/mg
        while(res = reg.exec(content)){
            res.shift()
            item = {
                url: btoa(res[0]),
                title:res[2],
                img: res[1].replace('http:','https:')
            }
            items.unshift(item);
        }

        var myHeaders = { 'Content-Type': 'application/json','Access-Control-Allow-Origin':'*','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
        var init = {"status":200, "statusText":"ok", headers: myHeaders};        
        response = new Response(JSON.stringify({'items': items.reverse()}), init)
        event.waitUntil(cache.put(event.request, response.clone()))
        return response
    }


    if(url.pathname == '\/getMovie'){
        let params = url.searchParams;
        let vid = params.get("vid");
        
        var fakeheader = makeHeader();
        response = await fetch(`${GATEWAY_URL}/view_video.php?page=1&viewtype=basic&category=mr&viewkey=`+ vid,fakeheader)
        var content = await response.text()
        c2 = content.replace(/[\n\t]/g,"").replace("  ","")
        //console.log(c2);
        //var reg2 = /<div id=\"viewvideo-title\">(.*?)<\/div>    <div id=\"viewvideo-content\">.*?poster=\"(.*?)\"      >.*?document\.write\(strencode\(\"(.*?)\"\)\)\;/mg
        var reg2 = /<div id=\"viewvideo-title\">(.*?)<\/div>    <div id=\"viewvideo-content\">.*?poster=\"(.*?)\"      >.*?source src=\"(.*?)\" type=\'video/mg
        res = reg2.exec(c2)
        //console.log(res)
        res.shift()
        item = {
            url: btoa(res[2]),
            title:res[0].trim(),
            img: res[1].replace('http:','https:')
        }

        var myHeaders = { 'Content-Type': 'application/json','Access-Control-Allow-Origin':'*','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
        var init = {"status":200, "statusText":"ok", headers: myHeaders};        
        response = new Response(JSON.stringify({'item': item}), init)
        event.waitUntil(cache.put(event.request, response.clone()))
        return response
    }

    if (!response) {
        response = await fetch(`${GATEWAY_URL}${url.pathname}`)
        const headers = { 'Content-Type': 'application/json','cache-control': 'public, max-age=14400', "Expires": expires.toUTCString() ,'Etag':'nicetomeetyoug' }
        response = new Response(response.body, { ...response, headers })
        event.waitUntil(cache.put(event.request, response.clone()))
    }
    return response
}

async function handleRequest(event) {
    if (event.request.method === 'GET') {
        let response = await serveApi(event)
        if (response.status > 399) {
            response = new Response(response.statusText, { status: response.status })
        }
        return response
    } else {
        return new Response('Method not allowed', { status: 405 })
    }
}
