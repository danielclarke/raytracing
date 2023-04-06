let clamp value ~lower ~upper =
  if value < lower then
    lower
  else if upper < value then
    upper
  else
    value
