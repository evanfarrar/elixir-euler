defmodule Sieve do
  def sieve(upto) do
    sieve([], Enum.to_list(2..round(Float.floor(:math.sqrt(upto)))), :math.sqrt(upto))
  end

  def sieve(primes, [head|tail], upto) when head < upto do
    sieve(primes ++ [head], Enum.reject(tail,  &(rem(&1,head)==0)), upto)
  end

  def sieve(primes, _list, _upto) do
    primes
  end
end
