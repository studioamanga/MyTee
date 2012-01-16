# API Documentation

## T-Shirts

### Getting all my t-shirts
*GET* `/api/tshirt/mine`
List all my t-shirts, as described with the following resource.

### Getting t-shirt description
*GET* `/api/tshirt/:tshirt_id`
	{
		"tshirt": {
			"identifier": "xxx",
			"name": "xxx",
			"size": "xxx",
			"color": "xxx",
			"condition": "xxx",
			"location-id": "xxx",
			"rating": xxx,
			"tags": "xxx",
			"store-id": "xxx",
			"note": "xxx"
		}
	}

## Store

## Location