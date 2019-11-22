## GET /api/v1/repositories/:id
Returns repository gems.

### Example

#### Request
```
GET /api/v1/repositories/975 HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 0
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 250
Content-Type: application/json; charset=utf-8
Referrer-Policy: strict-origin-when-cross-origin
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Permitted-Cross-Domain-Policies: none
X-Runtime: 0.006505
X-XSS-Protection: 1; mode=block

{
  "gemfiles": [
    {
      "path": "Gemfile.lock",
      "gems": [
        {
          "name": "gem1",
          "version": "0.1.0",
          "version_point": 1.0
        },
        {
          "name": "gem2",
          "version": "0.2.0",
          "version_point": 1.0
        }
      ]
    },
    {
      "path": "another/Gemfile.lock",
      "gems": [
        {
          "name": "gem3",
          "version": "0.3.0",
          "version_point": 1.0
        }
      ]
    }
  ]
}
```

## GET /api/v1/repositories
Returns repositories.

### Example

#### Request
```
GET /api/v1/repositories HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 0
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 405
Content-Type: application/json; charset=utf-8
Referrer-Policy: strict-origin-when-cross-origin
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Permitted-Cross-Domain-Policies: none
X-Runtime: 0.001612
X-XSS-Protection: 1; mode=block

[
  {
    "id": 976,
    "site": "site40",
    "repository_id": 40,
    "full_name": "cookpad/repo40",
    "ssh_url": "git@example.com:cookpad/repo40.git",
    "created_at": "2019-11-22T11:51:50.342Z",
    "updated_at": "2019-11-22T11:51:50.342Z"
  },
  {
    "id": 977,
    "site": "site41",
    "repository_id": 41,
    "full_name": "cookpad/repo41",
    "ssh_url": "git@example.com:cookpad/repo41.git",
    "created_at": "2019-11-22T11:51:50.343Z",
    "updated_at": "2019-11-22T11:51:50.343Z"
  }
]
```
