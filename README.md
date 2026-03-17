# Compound Interest Calculator API

Calculate compound interest.

## Endpoint

### GET `/calculate`

**Parameters:**
- `principal` (required): Principal amount
- `rate` (required): Interest rate (%)
- `time` (required): Time period (years)
- `compound` (required): Compounding frequency (1=yearly, 2=half-yearly, 4=quarterly, 12=monthly)

**Example Request:**
```
http://localhost:3020/calculate?principal=1000&rate=5&time=2&compound=12
```

**Example Response:**
```json
{
  "principal": 1000,
  "rate": 5,
  "time": 2,
  "compound": 12,
  "compoundInterest": 104.89,
  "total": 1104.89
}
```
