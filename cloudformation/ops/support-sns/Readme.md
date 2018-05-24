# GDP Support SNS Topic

Provide SNS topics to contact GDP's support.

## CPP Team
### Contacts
Production support includes:
- [x] CPP mailing list
- [x] CPP Support Phone
- [x] James' Phone
- [x] Joel's Phone
- [ ] Slack's #cpp-monitoring
 
Stage support includes:
- [x] CPP mailing list

### Command executed
```
aws cloudformation deploy --stack-name cpp-support --template-file cpp-support.yml
```