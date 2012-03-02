# API Documentation (v1.0 draft proposal)

## T-Shirts

### Getting all my t-shirts

**GET** `/api/store/all`

List all my t-shirts, as described with the following resource.

```
[
  {…}
]
```

### Getting t-shirt description

**GET** `/api/tshirt/:tshirt_id`

```
{
  "identifier": "xxx",
  "name": "xxx",
  "size": "xxx",
  "color": "xxx",
  "condition": "xxx",
  "location": "xxx",
  "rating": x,
  "tags": "xxx",
  "store": {...},
  "note": "xxx",
  "image_url": "xxx",
  "wear": 
  [
    {
      "identifier": "xxx",
      "date": "xxxx-xx-xx xx:xx:xx"
    }
  ],
  "wash":
  [
    {
      "identifier": "xxx",
      "date": "xxxx-xx-xx xx:xx:xx"
    }
  ]
}
```

### Wearing a t-shirt

**POST** `/api/tshirt/:tshirt_id/wear`

New `wear` record with `date = NOW`.

### Washing a t-shirt

**POST** `/api/tshirt/:tshirt_id/wash`

New `wash` record with `date = NOW`.

## Store

### Getting all my stores

**GET** `/api/store/all`

List all the stores, as described with the following resource.

```
[
  {…}
]
```

### Getting store description

**GET** `/api/store/:store_id`

```
{
  "identifier": "xxx",
  "name": "xxx",
  "type": "xxx",
  "address": "xxx",
  "url": "xxx",
  "latitude": xxx,
  "longitude": xxx
}
```

## User

### Authenticating user

**GET** `/api/user/me`

```
{
  "identifier": "xxx",
  "email": "xxx",
  "name": ""
}
```
