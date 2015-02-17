Stream.unfold({1,2}, fn({last, current}) -> if(current<=4000000,do: {{last, current},{current, last+current}}, else: nil) end ) |>
  Stream.filter(fn({_, current}) -> rem(current, 2) == 0 end) |>
  Stream.map(fn({_, current}) -> current end)                 |>
  Enum.to_list                                                |>
  Enum.sum                                                    |>
  IO.puts
