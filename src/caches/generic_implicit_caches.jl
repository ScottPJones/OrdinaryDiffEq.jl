mutable struct GenericImplicitEulerCache{uType,DiffCacheType,uNoUnitsType,rateType,rhsType,nl_rhsType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  uprev2::uType
  dual_cache::DiffCacheType
  tmp::uType
  atmp::uNoUnitsType
  k::rateType
  fsalfirst::rateType
  rhs::rhsType
  nl_rhs::nl_rhsType
end

u_cache(c::GenericImplicitEulerCache)    = (c.uprev2,)
du_cache(c::GenericImplicitEulerCache)   = (c.k,c.fsalfirst)
dual_cache(c::GenericImplicitEulerCache) = (c.dual_cache,)

function alg_cache(alg::GenericImplicitEuler,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits,indices(u))
  k = zeros(rate_prototype)
  dual_cache = DiffCache(u,Val{determine_chunksize(u,get_chunksize(alg.nlsolve))})
  rhs = ImplicitRHS(f,tmp,t,t,t,dual_cache)
  fsalfirst = zeros(rate_prototype)
  nl_rhs = alg.nlsolve(Val{:init},rhs,u)

  GenericImplicitEulerCache{typeof(u),typeof(dual_cache),
                     typeof(atmp),typeof(k),typeof(rhs),typeof(nl_rhs)}(
                     u,uprev,uprev2,dual_cache,tmp,atmp,k,fsalfirst,rhs,nl_rhs)
end

struct GenericImplicitEulerConstantCache{vecuType,rhsType,nl_rhsType} <: OrdinaryDiffEqConstantCache
  uhold::vecuType
  rhs::rhsType
  nl_rhs::nl_rhsType
end

function alg_cache(alg::GenericImplicitEuler,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  uhold = Vector{typeof(u)}(1)
  rhs = ImplicitRHS_Scalar(f,zero(u),t,t,t)
  nl_rhs = alg.nlsolve(Val{:init},rhs,uhold)
  GenericImplicitEulerConstantCache{typeof(uhold),typeof(rhs),typeof(nl_rhs)}(uhold,rhs,nl_rhs)
end

mutable struct GenericTrapezoidCache{uType,DiffCacheType,uNoUnitsType,rateType,rhsType,nl_rhsType,tType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  uprev2::uType
  fsalfirst::rateType
  dual_cache::DiffCacheType
  tmp::uType
  atmp::uNoUnitsType
  k::rateType
  rhs::rhsType
  nl_rhs::nl_rhsType
  uprev3::uType
  tprev2::tType
end

u_cache(c::GenericTrapezoidCache)    = (c.uprev2,c.uprev3)
du_cache(c::GenericTrapezoidCache)   = (c.k,c.fsalfirst)
dual_cache(c::GenericTrapezoidCache) = (c.dual_cache,)

function alg_cache(alg::GenericTrapezoid,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits,indices(u))
  k = zeros(rate_prototype)
  fsalfirst = zeros(rate_prototype)
  dual_cache = DiffCache(u,Val{determine_chunksize(u,get_chunksize(alg.nlsolve))})
  rhs = ImplicitRHS(f,tmp,t,t,t,dual_cache)
  nl_rhs = alg.nlsolve(Val{:init},rhs,u)
  uprev3 = similar(u)
  tprev2 = t
  GenericTrapezoidCache{typeof(u),typeof(dual_cache),typeof(atmp),typeof(k),
                        typeof(rhs),typeof(nl_rhs),typeof(t)}(
                        u,uprev,uprev2,fsalfirst,
                        dual_cache,tmp,atmp,k,rhs,nl_rhs,uprev3,tprev2)
end


mutable struct GenericTrapezoidConstantCache{vecuType,rhsType,nl_rhsType,uType,tType} <: OrdinaryDiffEqConstantCache
  uhold::vecuType
  rhs::rhsType
  nl_rhs::nl_rhsType
  uprev3::uType
  tprev2::tType
end

function alg_cache(alg::GenericTrapezoid,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  uhold = Vector{typeof(u)}(1)
  rhs = ImplicitRHS_Scalar(f,zero(u),t,t,t)
  nl_rhs = alg.nlsolve(Val{:init},rhs,uhold)
  uprev3 = u
  tprev2 = t
  GenericTrapezoidConstantCache(uhold,rhs,nl_rhs,uprev3,tprev2)
end

get_chunksize{uType,DiffCacheType,rateType,CS}(cache::GenericImplicitEulerCache{uType,DiffCacheType,rateType,CS}) = CS
get_chunksize{uType,DiffCacheType,rateType,CS}(cache::GenericTrapezoidCache{uType,DiffCacheType,rateType,CS}) = CS
