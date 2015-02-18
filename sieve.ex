defmodule Sieve do
  def sieve(upto) do
    max = upto
    head = 2
    Enum.to_list(sieve([], head, Stream.reject(3..upto, &(rem(&1,head)==0)), max))
  end

  def sieve(primes, head, unsieved, max) do
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
    primes = Sieve.sieve(round(Float.ceil(:math.sqrt(number))))
    Enum.find(Enum.reverse(primes), number, fn(prime) -> rem(number, prime) == 0 end)
  end

  def unique_prime_factors(number) do
    primes = Sieve.sieve(number)
    Enum.filter(Enum.reverse(primes), fn(prime) -> rem(number, prime) == 0 end)
  end

  def prime_factors(number) do
    if prime?(number) do
      [number]
    else
      prime_factors(number, [], Sieve.sieve(round(Float.floor(number/2))))
    end
  end

  def prime_factors(number, acc, primes) do
    prime = Enum.find(primes, nil, fn (prime) -> rem(number, prime) == 0 end)
    factor = round(number / prime)
    factors = acc ++ [prime]
    if prime?(factor) do
      factors = factors ++ [factor]
    else
      factors = factors ++ prime_factors(round(factor), [], primes)
    end
    factors
  end

  def prime?(number) do
    unique_prime_factors(round(number)) == [number]
  end 
end

defmodule LeastCommonMultiple do
  def lcm(numbers) do
    factors = Enum.map(numbers, &(PrimeFactorization.prime_factors&1))
    uniq_factors = Enum.flat_map(factors, &(&1)) |> Enum.uniq

    usages = Enum.map(uniq_factors, fn search_factor ->
      Enum.map(factors, fn factorization ->
        Enum.filter(factorization, fn factor ->
          search_factor == factor
        end)
      end) |> Enum.reject(fn factorizationn -> Enum.count(factorizationn) == 0 end)
    end)
    Enum.map(usages, fn (usage) -> { Enum.fetch!(usage, 0) |> Enum.fetch!(0), Enum.map(usage, fn(exponent) -> Enum.count(exponent) end) |> Enum.max } end) |> Enum.map(fn ({num,exp}) -> :math.pow(num,exp) end) |> Enum.reduce(&(&1*&2))
  end
end
