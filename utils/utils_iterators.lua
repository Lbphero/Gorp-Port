local _G = GLOBAL

function reduce(iterator, identity, fn)
    local result = identity
    for element in iterator do
        result = fn(result, element)
    end
    return result
end

function sum(iterator)
    return reduce(iterator, 0, function(x, y) x + y end)
end

_G.reduce = reduce
_G.sum = sum
