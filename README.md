# TAI64n

Swift package offering TAI64n label parsing to create a Date object, and a getter property to produce a TAI64n label.

It is implemented as an extension to the Date object

### Caveats

- It produces a full nanosecond component in the label which, when parsed will *very likely* not match the original. Ignoring the last byte of the label *should* be reliable.
- It is probably slow.
- It uses the new RegexBuilder because it can, and it is probably efficient, but I have not stressed this.

### Usage
```
	init?(tai64nLabel: String) -> Date?
	tai64nlabel: String
```

### Example

```
let dt = Date(tai64nLabel: "@400000000000000000000000") // 1969-12-31T23:59:50.000
dt?.tai64nlabel // @400000000000000000000000
```

