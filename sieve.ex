defmodule Sieve do
  def sieve(upto) do
    sieve([], Enum.to_list(2..upto), :math.sqrt(upto))
  end

  def sieve(primes, [head|tail], upto) when head < upto do
    sieve(primes ++ [head], Enum.reject(tail,  &(rem(&1,head)==0)), upto)
  end

  def sieve(primes, list, _upto) do
    primes ++ list
  end

  # newsieve was an attempt to do this lazily with streams; still took about the same time. Just keeping it to benchmark it with larger values later.
  def newsieve(upto) do
    max = round(Float.floor(:math.sqrt(upto)))
    head = 2
    Enum.to_list(sieve([], head, Stream.reject(3..upto, &(rem(&1,head)==0)), max))
  end

  def newsieve(primes, head, unsieved, max) do
    fetch_result = Stream.take(unsieved, 1) |> Enum.to_list |> Enum.fetch(0)
    newhead = case fetch_result do
                {:ok, value} -> value
                :error -> max
              end
    if(
      newhead < max,
      do: sieve(primes ++ [head], newhead, Stream.reject(Stream.drop(unsieved,1),  &(rem(&1,newhead)==0)), max),
      else: primes ++ [head] ++ Enum.to_list(unsieved)
    )
  end
end

defmodule PrimeFactorization do
  def largest_prime(number) do
    primes = Sieve.sieve(round(Float.floor(:math.sqrt(number))))
    Enum.find(Enum.reverse(primes), number, fn(prime) -> rem(number, prime) == 0 end)
  end
end
