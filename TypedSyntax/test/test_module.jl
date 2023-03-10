module TSN

# with two uses of the same slot in the same call. Must start on line 4 (or update the corresponding test)
function simplef(a, b)
    z = a * a
    return z + b
end

function has2xa(x)
    x &= x
end
function has2xb(x)
    x -= x
    return x
end

# This is taken from the definition of `sin(::Int)` in Base, copied here for testing purposes
# in case the implementation changes
for f in (:mysin,)
    @eval function ($f)(x::Real)
        xf = float(x)
        x === xf && throw(MethodError($f, (x,)))
        return ($f)(xf)
    end
end
mysin(x::AbstractFloat) = sin(x)

function summer(list)
    s = 0                    # deliberately ::Int to test type-changes
    for x in list
        s += x
    end
    return s
end

zerowhere(::AbstractArray{T}) where T<:Real = zero(T)
cb(a, i) = checkbounds(Bool, a, i)

add2(x) = x[1] + x[2]

myabs(x) = x < 0 ? -x : x

likevect(X::T...) where {T} = T[ X[i] for i = 1:length(X) ]
cbva(a, i...) = checkbounds(Bool, a, i...)
anykwargs(; kwargs...) = println(kwargs...)
splats(x, y) = vcat(x..., y...)

myoftype(ref, val) = typeof(ref)(val)

defaultarg(x, y=2) = x + y
hasdefaulttypearg(::Type{T}=Rational{Int}) where T = zero(T)

charset1 = 'a':'z'
getchar1(idx) = charset1[idx]
const charset2 = 'a':'z'
getchar2(idx) = charset2[idx]

# unused statements
function mycheckbounds(A, i)
    checkbounds(Bool, A, i) || Base.throw_boundserror(A, i)
    return nothing
end

# Implementation of a struct & interface
struct DefaultArray{T,N,A<:AbstractArray{T,N}} <: AbstractArray{T,N}
    parentarray::A
    defaultvalue::T
end
DefaultArray(parentarray, defaultvalue) = DefaultArray{ndims(parentarray)}(parentarray, defaultvalue)
Base.getindex(a::DefaultArray{T,N}, i::Vararg{Int,N}) where {T,N} = checkbounds(Bool, a, i...) ? a.parentarray[i...] : a.defaultvalue
Base.size(a::DefaultArray) = size(a.parentarray)

# macros in the function body (which introduce novel symbols)
function hasmacro(t, x)
    rand()
    convert(Base.@default_eltype(t), x)
end

# This has a TypedSlot in an indexed_iterate call
function typeof_first_item(g::Base.Generator)
    y = iterate(g)
    y === nothing && return Nothing
    val, s = y
    return typeof(val)
end

end
