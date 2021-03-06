struct EulerCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::uType
  k::rateType
  fsalfirst::rateType
end

struct SplitEulerCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::uType
  k::rateType
  fsalfirst::rateType
end

function alg_cache(alg::SplitEuler,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  SplitEulerCache(u,uprev,similar(u),zeros(rate_prototype),zeros(rate_prototype))
end

u_cache(c::SplitEulerCache) = ()
du_cache(c::SplitEulerCache) = (c.k,c.fsalfirst)

struct SplitEulerConstantCache <: OrdinaryDiffEqConstantCache end

alg_cache(alg::SplitEuler,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = SplitEulerConstantCache()

function alg_cache(alg::Euler,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  EulerCache(u,uprev,similar(u),zeros(rate_prototype),zeros(rate_prototype))
end

u_cache(c::EulerCache) = ()
du_cache(c::EulerCache) = (c.k,c.fsalfirst)

struct EulerConstantCache <: OrdinaryDiffEqConstantCache end

alg_cache(alg::Euler,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = EulerConstantCache()

struct HeunCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::uType
  k::rateType
  utilde::rateType
  fsalfirst::rateType
end

struct RalstonCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  tmp::uType
  k::rateType
  utilde::rateType
  fsalfirst::rateType
end

u_cache(c::Union{HeunCache,RalstonCache}) = ()
du_cache(c::Union{HeunCache,RalstonCache}) = (c.k,c.fsalfirst,c.utilde)

function alg_cache(alg::Heun,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  HeunCache(u,uprev,similar(u),zeros(rate_prototype),zeros(rate_prototype),zeros(rate_prototype))
end

function alg_cache(alg::Ralston,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  RalstonCache(u,uprev,similar(u),zeros(rate_prototype),zeros(rate_prototype),zeros(rate_prototype))
end

struct HeunConstantCache <: OrdinaryDiffEqConstantCache end

alg_cache(alg::Heun,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = HeunConstantCache()

struct RalstonConstantCache <: OrdinaryDiffEqConstantCache end

alg_cache(alg::Ralston,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = RalstonConstantCache()

struct MidpointCache{uType,rateType,uEltypeNoUnits} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k::rateType
  tmp::uType
  atmp::uEltypeNoUnits
  fsalfirst::rateType
end

u_cache(c::MidpointCache) = (c.atmp,)
du_cache(c::MidpointCache) = (c.k,c.fsalfirst)

struct MidpointConstantCache <: OrdinaryDiffEqConstantCache end

function alg_cache(alg::Midpoint,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tmp = similar(u); atmp = similar(u, uEltypeNoUnits)
  k = zeros(rate_prototype)
  fsalfirst = zeros(rate_prototype)
  MidpointCache(u,uprev,k,tmp,atmp,fsalfirst)
end

alg_cache(alg::Midpoint,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = MidpointConstantCache()

struct RK4Cache{uType,rateType,uEltypeNoUnits} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  fsalfirst::rateType
  k₂::rateType
  k₃::rateType
  k₄::rateType
  k::rateType
  tmp::uType
  atmp::uEltypeNoUnits
end

u_cache(c::RK4Cache) = (c.atmp,)
du_cache(c::RK4Cache) = (c.fsalfirst,c.k₂,c.k₃,c.k₄,c.k)

struct RK4ConstantCache <: OrdinaryDiffEqConstantCache end

function alg_cache(alg::RK4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  k₁ = zeros(rate_prototype)
  k₂ = zeros(rate_prototype)
  k₃ = zeros(rate_prototype)
  k₄ = zeros(rate_prototype)
  k  = zeros(rate_prototype)
  tmp = similar(u); atmp = similar(u, uEltypeNoUnits)
  RK4Cache(u,uprev,k₁,k₂,k₃,k₄,k,tmp,atmp)
end

alg_cache(alg::RK4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = RK4ConstantCache()


struct CarpenterKennedy2N54Cache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k::rateType
  tmp::uType
  fsalfirst::rateType
  A2::Float64
  A3::Float64
  A4::Float64
  A5::Float64
  B1::Float64
  B2::Float64
  B3::Float64
  B4::Float64
  B5::Float64
  c2::Float64
  c3::Float64
  c4::Float64
  c5::Float64
end

u_cache(c::CarpenterKennedy2N54Cache) = ()
du_cache(c::CarpenterKennedy2N54Cache) = (c.k,c.fsalfirst)

struct CarpenterKennedy2N54ConstantCache <: OrdinaryDiffEqConstantCache
  A2::Float64
  A3::Float64
  A4::Float64
  A5::Float64
  B1::Float64
  B2::Float64
  B3::Float64
  B4::Float64
  B5::Float64
  c2::Float64
  c3::Float64
  c4::Float64
  c5::Float64
end

function alg_cache(alg::CarpenterKennedy2N54,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tmp = similar(u)
  k = zeros(rate_prototype)
  fsalfirst = zeros(rate_prototype)
  A2 = -567301805773/1357537059087
  A3 = -2404267990393/2016746695238
  A4 = -3550918686646/2091501179385
  A5 = -1275806237668/842570457699
  B1 = 1432997174477/9575080441755
  B2 = 5161836677717/13612068292357
  B3 = 1720146321549/2090206949498
  B4 = 3134564353537/4481467310338
  B5 = 2277821191437/14882151754819
  c2 = 1432997174477/9575080441755
  c3 = 2526269341429/6820363962896
  c4 = 2006345519317/3224310063776
  c5 = 2802321613138/2924317926251
  CarpenterKennedy2N54Cache(u,uprev,k,tmp,fsalfirst,A2,A3,A4,A5,B1,B2,B3,B4,B5,c2,c3,c4,c5)
end

function alg_cache(alg::CarpenterKennedy2N54,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  A2 = -567301805773/1357537059087
  A3 = -2404267990393/2016746695238
  A4 = -3550918686646/2091501179385
  A5 = -1275806237668/842570457699
  B1 = 1432997174477/9575080441755
  B2 = 5161836677717/13612068292357
  B3 = 1720146321549/2090206949498
  B4 = 3134564353537/4481467310338
  B5 = 2277821191437/14882151754819
  c2 = 1432997174477/9575080441755
  c3 = 2526269341429/6820363962896
  c4 = 2006345519317/3224310063776
  c5 = 2802321613138/2924317926251
  CarpenterKennedy2N54ConstantCache(A2,A3,A4,A5,B1,B2,B3,B4,B5,c2,c3,c4,c5)
end



struct BS3Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  fsalfirst::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::BS3Cache) = (c.atmp,c.utilde)
du_cache(c::BS3Cache) = (c.fsalfirst,c.k2,c.k3,c.k4)

function alg_cache(alg::BS3,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = BS3ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  BS3Cache(u,uprev,k1,k2,k3,k4,utilde,tmp,atmp,tab)
end

alg_cache(alg::BS3,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = BS3ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct OwrenZen3Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::OwrenZen3Cache) = (c.atmp,c.utilde)
du_cache(c::OwrenZen3Cache) = (c.k1,c.k2,c.k3,c.k4)

function alg_cache(alg::OwrenZen3,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = OwrenZen3ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  OwrenZen3Cache(u,uprev,k1,k2,k3,k4,utilde,tmp,atmp,tab)
end

alg_cache(alg::OwrenZen3,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = OwrenZen3ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct OwrenZen4Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::OwrenZen4Cache) = (c.atmp,c.utilde)
du_cache(c::OwrenZen4Cache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6)

function alg_cache(alg::OwrenZen4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = OwrenZen4ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  OwrenZen4Cache(u,uprev,k1,k2,k3,k4,k5,k6,utilde,tmp,atmp,tab)
end

alg_cache(alg::OwrenZen4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = OwrenZen4ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct OwrenZen5Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::OwrenZen5Cache) = (c.atmp,c.utilde)
du_cache(c::OwrenZen5Cache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6,c.k7,c.k8)

function alg_cache(alg::OwrenZen5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = OwrenZen5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = zeros(rate_prototype)
  k7 = zeros(rate_prototype)
  k8 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  OwrenZen5Cache(u,uprev,k1,k2,k3,k4,k5,k6,k7,k8,utilde,tmp,atmp,tab)
end

alg_cache(alg::OwrenZen5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = OwrenZen5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct BS5Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::BS5Cache) = (c.utilde,c.atmp)
du_cache(c::BS5Cache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6,c.k7,c.k8)

function alg_cache(alg::BS5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = BS5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = zeros(rate_prototype)
  k7 = zeros(rate_prototype)
  k8 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits,indices(u))
  tmp = similar(u)
  BS5Cache(u,uprev,k1,k2,k3,k4,k5,k6,k7,k8,utilde,tmp,atmp,tab)
end

alg_cache(alg::BS5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = BS5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct Tsit5Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::Tsit5Cache) = (c.utilde,c.atmp)
du_cache(c::Tsit5Cache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6,c.k7)

function alg_cache(alg::Tsit5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tab = Tsit5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = zeros(rate_prototype)
  k7 = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  atmp = similar(u,uEltypeNoUnits,indices(u))
  tmp = similar(u)
  Tsit5Cache(u,uprev,k1,k2,k3,k4,k5,k6,k7,utilde,tmp,atmp,tab)
end

alg_cache(alg::Tsit5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = Tsit5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct DP5Cache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  dense_tmp3::rateType
  dense_tmp4::rateType
  update::rateType
  bspl::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::DP5Cache) = (c.utilde,c.atmp)
du_cache(c::DP5Cache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6,c.k7,c.dense_tmp3,c.dense_tmp4,c.update,c.bspl)

function alg_cache(alg::DP5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = k2
  k7 = zeros(rate_prototype)
  dense_tmp3 = k2
  dense_tmp4 = k5
  update = zeros(rate_prototype)
  bspl = k3
  utilde = similar(u,indices(u))
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits,indices(u))
  tab = DP5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  cache = DP5Cache(u,uprev,k1,k2,k3,k4,k5,k6,k7,dense_tmp3,dense_tmp4,update,bspl,utilde,tmp,atmp,tab)
  cache
end

alg_cache(alg::DP5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}}) = DP5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

struct DP5ThreadedCache{uType,uArrayType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  dense_tmp3::rateType
  dense_tmp4::rateType
  update::rateType
  bspl::rateType
  utilde::uArrayType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

u_cache(c::DP5ThreadedCache) = (c.utilde,c.atmp)
du_cache(c::DP5ThreadedCache) = (c.k1,c.k2,c.k3,c.k4,c.k5,c.k6,c.k7,c.dense_tmp3,c.dense_tmp4,c.update,c.bspl)

function alg_cache(alg::DP5Threaded,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  k1 = zeros(rate_prototype)
  k2 = zeros(rate_prototype)
  k3 = zeros(rate_prototype)
  k4 = zeros(rate_prototype)
  k5 = zeros(rate_prototype)
  k6 = zeros(rate_prototype)
  k7 = zeros(rate_prototype)
  dense_tmp3 = zeros(rate_prototype)
  dense_tmp4 = zeros(rate_prototype)
  update = zeros(rate_prototype)
  bspl = zeros(rate_prototype)
  utilde = similar(u,indices(u))
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits,indices(u))
  tab = DP5ConstantCache(real(uBottomEltypeNoUnits),real(tTypeNoUnits))
  DP5ThreadedCache(u,uprev,k1,k2,k3,k4,k5,k6,k7,dense_tmp3,dense_tmp4,update,bspl,utilde,tmp,atmp,tab)
end
