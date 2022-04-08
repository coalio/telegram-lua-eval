-- A buffered print function that replaces the global print function.

print_buffer = {}

function buffered_print(...)
  local args = {...}
  for i = 1, #args do
    args[i] = tostring(args[i])
  end
  table.insert(print_buffer, table.concat(args, ' '))
end

function pop_print_buffer()
  local result = table.concat(print_buffer, '\n')
  print_buffer = {}
  return result
end