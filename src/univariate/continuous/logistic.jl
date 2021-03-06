immutable Logistic <: ContinuousUnivariateDistribution
    μ::Float64
    θ::Float64

    Logistic(μ::Real, θ::Real) = (@check_args(Logistic, θ > zero(θ)); new(μ, θ))
    Logistic(μ::Real) = new(μ, 1.0)
    Logistic() = new(0.0, 1.0)
end

@distr_support Logistic -Inf Inf


#### Parameters

location(d::Logistic) = d.μ
scale(d::Logistic) = d.θ

params(d::Logistic) = (d.μ, d.θ)


#### Statistics

mean(d::Logistic) = d.μ
median(d::Logistic) = d.μ
mode(d::Logistic) = d.μ

std(d::Logistic) = π * d.θ / sqrt3
var(d::Logistic) = (π * d.θ)^2 / 3.0
skewness(d::Logistic) = 0.0
kurtosis(d::Logistic) = 1.2

entropy(d::Logistic) = log(d.θ) + 2.0


#### Evaluation

zval(d::Logistic, x::Float64) = (x - d.μ) / d.θ
xval(d::Logistic, z::Float64) = d.μ + z * d.θ

pdf(d::Logistic, x::Float64) = (e = exp(-zval(d, x)); e / (d.θ * (1.0 + e)^2))
logpdf(d::Logistic, x::Float64) = (u = -abs(zval(d, x)); u - 2.0 * log1pexp(u) - log(d.θ))

cdf(d::Logistic, x::Float64) = logistic(zval(d, x))
ccdf(d::Logistic, x::Float64) = logistic(-zval(d, x))
logcdf(d::Logistic, x::Float64) = -log1pexp(-zval(d, x))
logccdf(d::Logistic, x::Float64) = -log1pexp(zval(d, x))

quantile(d::Logistic, p::Float64) = xval(d, logit(p))
cquantile(d::Logistic, p::Float64) = xval(d, -logit(p))
invlogcdf(d::Logistic, lp::Float64) = xval(d, -logexpm1(-lp))
invlogccdf(d::Logistic, lp::Float64) = xval(d, logexpm1(-lp))

function gradlogpdf(d::Logistic, x::Float64)
    e = exp(-zval(d, x))
    ((2.0 * e) / (1.0 + e) - 1.0) / d.θ
end

mgf(d::Logistic, t::Real) = exp(t * d.μ) / sinc(d.θ * t)

function cf(d::Logistic, t::Real)
    a = (π * t) * d.θ
    a == zero(a) ? complex(one(a)) : cis(t * d.μ) * (a / sinh(a))
end


#### Sampling

rand(d::Logistic) = quantile(d, rand())
