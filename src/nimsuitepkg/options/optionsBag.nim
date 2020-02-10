type OptionValue*[T: enum] = tuple
  option: T
  value: string

type OptionBag*[T: enum] = seq[OptionValue[T]]

proc makeOptionBag*[T: enum](): OptionBag[T] =
  return @[]

proc add*[T: enum](b: var OptionBag[T], o: T, v: string = "") =
  var ov: OptionValue[T] = (o, v)
  b.add(ov)

proc contains*[T: enum](b: OptionBag[T], o: T): bool =
  for ov in b.items:
    if ov.option == o:
      return true
  return false

proc find*[T: enum](b: OptionBag[T], o: T): OptionValue[T] =
  for ov in b.items:
    if ov.option == o:
      return ov
  return
