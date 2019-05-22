## certificate-aliyun
List, new, renew let's encrypt wildcard certificate, domain on aliyun

## How to use
First, you need creat a file on root directory named `aliyun_access_key`, set aliyun access key in it:

```
ACCESS_KEY_ID: <your key id>
ACCESS_KEY_SECRET: <your key secret>
```

and then:

### List certificate
`./cert.sh`

### Request certificate
`./cert.sh new -d <domain>`

### Renew certificate
`./cert.sh renew`

### Help
`./cert.sh -h|--help|help`

## Reference
* [ywdblog/certbot-letencrypt-wildcardcertificates-alydns-au](https://github.com/ywdblog/certbot-letencrypt-wildcardcertificates-alydns-au)
