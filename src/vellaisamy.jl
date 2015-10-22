
export NegativeBinomialSum, pmf

"""
This is based on the paper:
"On the sums of compound negative binomial and gamma random variables" by Vallaisamy, 2009
http://projecteuclid.org/euclid.jap/1238592129
"""
type NegativeBinomialSum
    rs::Array{Int64,1}
    ps::Array{Float64,1}
end


"Call f on all possible ways n non-negative integers can sum to equal s."
function allsums_apply(f::Function, n::Int, s::Int)
    if n == 1
        f([s])
    elseif n == 2
        for i in 0:s
            f(Int64[i,s-i])
        end
    elseif n == 3
        for i in 0:s
            for j in 0:s
                if i + j > s break end
                f(Int64[i,j,s-i-j])
            end
        end
    elseif n == 4
        for i in 0:s
            for j in 0:s
                if i + j > s break end
                for k in 0:s
                    if i + j + k > s break end
                    f(Int64[i,j,k,s-i-j-k])
                end
            end
        end
    elseif n == 5
        for i in 0:s
            for j in 0:s
                if i + j > s break end
                for k in 0:s
                    if i + j + k > s break end
                    for l in 0:s
                        if i + j + k + l > s break end
                        f(Int64[i,j,k,l,s-i-j-k-l])
                    end
                end
            end
        end
    else
        error("n = $n is not yet implemented.")
    end
end

"Compute the exact PMF at the given point with a sum."
function pmf(d::NegativeBinomialSum, s::Int)
    total = 0.0

    function inner_term(m)
        val = 1.0
        for j in 1:length(d.ps)
            val *= binomial(d.rs[j] + m[j] - 1, m[j])*d.ps[j]^d.rs[j]*(1-d.ps[j])^m[j]
        end
        total += val
    end
    allsums_apply(inner_term, length(d.ps), s)
    total
end