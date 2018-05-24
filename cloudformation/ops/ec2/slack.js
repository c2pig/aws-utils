var http = require ('https');
var querystring = require ('querystring');
exports.handler = function(event, context) {
    var regions = [
        {name:'Virginia', region:'us-east-1'},
        {name:'Ohio', region:'us-east-2'}, 
        {name:'California', region:'us-west-1'}, 
        {name:'Oregon', region:'us-west-2'}, 
        {name:'Mumbai', region:'ap-south-1'}, 
        {name:'Seoul', region:'ap-northeast-2'}, 
        {name:'Singapore', region:'ap-southeast-1'}, 
        {name:'Sydney', region:'ap-southeast-2'}, 
        {name:'Tokyo', region:'ap-northeast-1'}, 
        {name:'Frankfurt', region:'eu-central-1'},
        {name:'Ireland', region:'eu-west-1'},
        {name:'London', region:'eu-west-2'}
    ];
    console.log(event.Records[0].Sns);
    var message = JSON.parse(event.Records[0].Sns.Message);
    console.log(message); 
    var color = 'warning';
    switch(message.NewStateValue) {
        case "OK":
            color = 'good';
            break;
        case "ALARM":
            color = 'danger';
            break;
    }
    
    var regionObj = regions.filter((x) => { return message.Region.indexOf(x.name) != -1})[0];
    var asg = message.Trigger.Dimensions[0].value;
    var envId= asg.split('-')[1] + "-" + asg.split('-')[2];
    console.log(regionObj);
    var region = regionObj.region;
    var payloadStr = JSON.stringify({
        "username": "Cloudwatch",
        "attachments": [
            {
                "title": message.AlarmName,
                "fallback": message.NewStateReason,
                "text": message.NewStateReason,
                "fields": [
                    {
                        "title": "Region",
                        "value": message.Region,
                        "short": true
                    },
                    {
                        "title": "State",
                        "value": message.NewStateValue,
                        "short": true
                    }
                ],
                "color": color
            }
        ],
        "icon_emoji": ":cloudwatch:"
    });
 
    var postData = querystring.stringify({
      "payload": payloadStr
    });
 
    var options = {
        hostname: 'hooks.slack.com',
        port: 443,
        path: process.env.hookUri,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': postData.length
        }
    };
 
    var req = http.request(options, function(res) {
        res.on("data", function(chunk) {
            console.log(chunk);
            context.done(null, 'done!');
        });
    }).on('error', function(e) {
        context.done('error', e);
    });
    req.write(postData);
    req.end();
};
