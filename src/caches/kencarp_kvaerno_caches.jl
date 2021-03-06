mutable struct KenCarp3ConstantCache{F,uEltypeNoUnits,Tab} <: OrdinaryDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

function alg_cache(alg::KenCarp3,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  if typeof(f) <: SplitFunction
    uf = DiffEqDiffTools.UDerivativeWrapper(f.f1,t)
  else
    uf = DiffEqDiffTools.UDerivativeWrapper(f,t)
  end
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp3Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  KenCarp3ConstantCache(uf,ηold,κ,tol,10000,tab)
end

mutable struct KenCarp3Cache{uType,rateType,uNoUnitsType,J,UF,JC,uEltypeNoUnits,Tab,F,kType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z₁::uType
  z₂::uType
  z₃::uType
  z₄::uType
  k1::kType
  k2::kType
  k3::kType
  k4::kType
  dz::uType
  b::uType
  tmp::uType
  atmp::uNoUnitsType
  J::J
  W::J
  uf::UF
  jac_config::JC
  linsolve::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

u_cache(c::KenCarp3Cache)    = (c.z₁,c.z₂,c.z₃,c.z₄,c.dz)
du_cache(c::KenCarp3Cache)   = (c.k,c.fsalfirst)

function alg_cache(alg::KenCarp3,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,
                   tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})

  du1 = zeros(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J)
  z₁ = similar(u,indices(u)); z₂ = similar(u,indices(u))
  z₃ = similar(u,indices(u)); z₄ = similar(u,indices(u))
  dz = similar(u,indices(u))
  fsalfirst = zeros(rate_prototype)
  k = zeros(rate_prototype)
  tmp = similar(u); b = similar(u,indices(u));
  atmp = similar(u,uEltypeNoUnits,indices(u))

  if typeof(f) <: SplitFunction
    k1 = similar(u,indices(u)); k2 = similar(u,indices(u))
    k3 = similar(u,indices(u)); k4 = similar(u,indices(u))
    uf = DiffEqDiffTools.UJacobianWrapper(f.f1,t)
  else
    k1 = nothing; k2 = nothing
    k3 = nothing; k4 = nothing
    uf = DiffEqDiffTools.UJacobianWrapper(f,t)
  end
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp3Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  ηold = one(uEltypeNoUnits)

  KenCarp3Cache{typeof(u),typeof(rate_prototype),typeof(atmp),typeof(J),typeof(uf),
              typeof(jac_config),uEltypeNoUnits,typeof(tab),typeof(linsolve),typeof(k1)}(
              u,uprev,du1,fsalfirst,k,z₁,z₂,z₃,z₄,k1,k2,k3,k4,dz,b,tmp,atmp,J,
              W,uf,jac_config,linsolve,ηold,κ,tol,10000,tab)
end

mutable struct Kvaerno4ConstantCache{F,uEltypeNoUnits,Tab} <: OrdinaryDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

function alg_cache(alg::Kvaerno4,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  uf = DiffEqDiffTools.UDerivativeWrapper(f,t)
  ηold = one(uEltypeNoUnits)
  uprev3 = u
  tprev2 = t

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = Kvaerno4Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  Kvaerno4ConstantCache(uf,ηold,κ,tol,10000,tab)
end

mutable struct Kvaerno4Cache{uType,rateType,uNoUnitsType,J,UF,JC,uEltypeNoUnits,Tab,F} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z₁::uType
  z₂::uType
  z₃::uType
  z₄::uType
  z₅::uType
  dz::uType
  b::uType
  tmp::uType
  atmp::uNoUnitsType
  J::J
  W::J
  uf::UF
  jac_config::JC
  linsolve::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

u_cache(c::Kvaerno4Cache)    = (c.z₁,c.z₂,c.z₃,c.z₄,c.z₅,c.dz₁,c.dz₂,c.dz₃,c.dz₄,c.dz₅)
du_cache(c::Kvaerno4Cache)   = (c.k,c.fsalfirst)

function alg_cache(alg::Kvaerno4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,
                   tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})

  du1 = zeros(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J)
  z₁ = similar(u,indices(u)); z₂ = similar(u,indices(u));
  z₃ = similar(u,indices(u)); z₄ = similar(u,indices(u))
  z₅ = similar(u,indices(u))
  dz = similar(u,indices(u))
  fsalfirst = zeros(rate_prototype)
  k = zeros(rate_prototype)
  tmp = similar(u); b = similar(u,indices(u));
  atmp = similar(u,uEltypeNoUnits,indices(u))

  uf = DiffEqDiffTools.UJacobianWrapper(f,t)
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = Kvaerno4Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  ηold = one(uEltypeNoUnits)

  Kvaerno4Cache{typeof(u),typeof(rate_prototype),typeof(atmp),typeof(J),typeof(uf),
              typeof(jac_config),uEltypeNoUnits,typeof(tab),typeof(linsolve)}(
              u,uprev,du1,fsalfirst,k,z₁,z₂,z₃,z₄,z₅,dz,b,tmp,atmp,J,
              W,uf,jac_config,linsolve,ηold,κ,tol,10000,tab)
end

mutable struct KenCarp4ConstantCache{F,uEltypeNoUnits,Tab} <: OrdinaryDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

function alg_cache(alg::KenCarp4,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  if typeof(f) <: SplitFunction
    uf = DiffEqDiffTools.UDerivativeWrapper(f.f1,t)
  else
    uf = DiffEqDiffTools.UDerivativeWrapper(f,t)
  end
  ηold = one(uEltypeNoUnits)
  uprev3 = u
  tprev2 = t

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp4Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  KenCarp4ConstantCache(uf,ηold,κ,tol,10000,tab)
end

mutable struct KenCarp4Cache{uType,rateType,uNoUnitsType,J,UF,JC,uEltypeNoUnits,Tab,F,kType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z₁::uType
  z₂::uType
  z₃::uType
  z₄::uType
  z₅::uType
  z₆::uType
  k1::kType
  k2::kType
  k3::kType
  k4::kType
  k5::kType
  k6::kType
  dz::uType
  b::uType
  tmp::uType
  atmp::uNoUnitsType
  J::J
  W::J
  uf::UF
  jac_config::JC
  linsolve::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

u_cache(c::KenCarp4Cache)    = (c.z₁,c.z₂,c.z₃,c.z₄,c.z₅,c.z₆,c.dz)
du_cache(c::KenCarp4Cache)   = (c.k,c.fsalfirst)

function alg_cache(alg::KenCarp4,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,
                   tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})

  du1 = zeros(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J)
  z₁ = similar(u,indices(u)); z₂ = similar(u,indices(u))
  z₃ = similar(u,indices(u)); z₄ = similar(u,indices(u))
  z₅ = similar(u,indices(u)); z₆ = similar(u,indices(u))
  dz = similar(u,indices(u))
  fsalfirst = zeros(rate_prototype)
  k = zeros(rate_prototype)
  tmp = similar(u); b = similar(u,indices(u));
  atmp = similar(u,uEltypeNoUnits,indices(u))

  if typeof(f) <: SplitFunction
    k1 = similar(u,indices(u)); k2 = similar(u,indices(u))
    k3 = similar(u,indices(u)); k4 = similar(u,indices(u))
    k5 = similar(u,indices(u)); k6 = similar(u,indices(u))
    uf = DiffEqDiffTools.UJacobianWrapper(f.f1,t)
  else
    k1 = nothing; k2 = nothing
    k3 = nothing; k4 = nothing
    k5 = nothing; k6 = nothing
    uf = DiffEqDiffTools.UJacobianWrapper(f,t)
  end
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp4Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  ηold = one(uEltypeNoUnits)

  KenCarp4Cache{typeof(u),typeof(rate_prototype),typeof(atmp),typeof(J),typeof(uf),
              typeof(jac_config),uEltypeNoUnits,typeof(tab),typeof(linsolve),typeof(k1)}(
              u,uprev,du1,fsalfirst,k,z₁,z₂,z₃,z₄,z₅,z₆,k1,k2,k3,k4,k5,k6,
              dz,b,tmp,atmp,J,
              W,uf,jac_config,linsolve,ηold,κ,tol,10000,tab)
end

mutable struct Kvaerno5ConstantCache{F,uEltypeNoUnits,Tab} <: OrdinaryDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

function alg_cache(alg::Kvaerno5,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  uf = DiffEqDiffTools.UDerivativeWrapper(f,t)
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = Kvaerno5Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  Kvaerno5ConstantCache(uf,ηold,κ,tol,10000,tab)
end

mutable struct Kvaerno5Cache{uType,rateType,uNoUnitsType,J,UF,JC,uEltypeNoUnits,Tab,F} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z₁::uType
  z₂::uType
  z₃::uType
  z₄::uType
  z₅::uType
  z₆::uType
  z₇::uType
  dz::uType
  b::uType
  tmp::uType
  atmp::uNoUnitsType
  J::J
  W::J
  uf::UF
  jac_config::JC
  linsolve::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

u_cache(c::Kvaerno5Cache)    = (c.z₁,c.z₂,c.z₃,c.z₄,c.z₅,c.z₆,c.z₇,c.dz)
du_cache(c::Kvaerno5Cache)   = (c.k,c.fsalfirst)

function alg_cache(alg::Kvaerno5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,
                   tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})

  du1 = zeros(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J)
  z₁ = similar(u,indices(u)); z₂ = similar(u,indices(u));
  z₃ = similar(u,indices(u)); z₄ = similar(u,indices(u))
  z₅ = similar(u,indices(u)); z₆ = similar(u,indices(u));
  z₇ = similar(u,indices(u))
  dz = similar(u,indices(u))
  fsalfirst = zeros(rate_prototype)
  k = zeros(rate_prototype)
  tmp = similar(u); b = similar(u,indices(u));
  atmp = similar(u,uEltypeNoUnits,indices(u))

  uf = DiffEqDiffTools.UJacobianWrapper(f,t)
  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = Kvaerno5Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  ηold = one(uEltypeNoUnits)

  Kvaerno5Cache{typeof(u),typeof(rate_prototype),typeof(atmp),typeof(J),typeof(uf),
              typeof(jac_config),uEltypeNoUnits,typeof(tab),typeof(linsolve)}(
              u,uprev,du1,fsalfirst,k,z₁,z₂,z₃,z₄,z₅,z₆,z₇,dz,b,tmp,atmp,J,
              W,uf,jac_config,linsolve,ηold,κ,tol,10000,tab)
end

mutable struct KenCarp5ConstantCache{F,uEltypeNoUnits,Tab} <: OrdinaryDiffEqConstantCache
  uf::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

function alg_cache(alg::KenCarp5,u,rate_prototype,uEltypeNoUnits,tTypeNoUnits,uBottomEltypeNoUnits,
                   uprev,uprev2,f,t,dt,reltol,::Type{Val{false}})
  if typeof(f) <: SplitFunction
    uf = DiffEqDiffTools.UDerivativeWrapper(f.f1,t)
  else
    uf = DiffEqDiffTools.UDerivativeWrapper(f,t)
  end
  ηold = one(uEltypeNoUnits)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp5Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  KenCarp5ConstantCache(uf,ηold,κ,tol,10000,tab)
end

mutable struct KenCarp5Cache{uType,rateType,uNoUnitsType,J,UF,JC,uEltypeNoUnits,Tab,F,kType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  du1::rateType
  fsalfirst::rateType
  k::rateType
  z₁::uType
  z₂::uType
  z₃::uType
  z₄::uType
  z₅::uType
  z₆::uType
  z₇::uType
  z₈::uType
  k1::kType
  k2::kType
  k3::kType
  k4::kType
  k5::kType
  k6::kType
  k7::kType
  k8::kType
  dz::uType
  b::uType
  tmp::uType
  atmp::uNoUnitsType
  J::J
  W::J
  uf::UF
  jac_config::JC
  linsolve::F
  ηold::uEltypeNoUnits
  κ::uEltypeNoUnits
  tol::uEltypeNoUnits
  newton_iters::Int
  tab::Tab
end

u_cache(c::KenCarp5Cache)    = (c.z₁,c.z₂,c.z₃,c.z₄,c.z₅,c.z₆,c.z₇,c.z₈,c.dz)
du_cache(c::KenCarp5Cache)   = (c.k,c.fsalfirst)

function alg_cache(alg::KenCarp5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,
                   tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,::Type{Val{true}})

  du1 = zeros(rate_prototype)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J)
  z₁ = similar(u,indices(u)); z₂ = similar(u,indices(u));
  z₃ = similar(u,indices(u)); z₄ = similar(u,indices(u))
  z₅ = similar(u,indices(u)); z₆ = similar(u,indices(u));
  z₇ = similar(u,indices(u)); z₈ = similar(u,indices(u))
  dz = similar(u,indices(u))
  fsalfirst = zeros(rate_prototype)
  k = zeros(rate_prototype)
  tmp = similar(u); b = similar(u,indices(u));
  atmp = similar(u,uEltypeNoUnits,indices(u))

  if typeof(f) <: SplitFunction
    k1 = similar(u,indices(u)); k2 = similar(u,indices(u))
    k3 = similar(u,indices(u)); k4 = similar(u,indices(u))
    k5 = similar(u,indices(u)); k6 = similar(u,indices(u))
    k7 = similar(u,indices(u)); k8 = similar(u,indices(u))
    uf = DiffEqDiffTools.UJacobianWrapper(f.f1,t)
  else
    k1 = nothing; k2 = nothing
    k3 = nothing; k4 = nothing
    k5 = nothing; k6 = nothing
    k7 = nothing; k8 = nothing
    uf = DiffEqDiffTools.UJacobianWrapper(f,t)
  end

  linsolve = alg.linsolve(Val{:init},uf,u)
  jac_config = build_jac_config(alg,f,uf,du1,uprev,u,tmp,dz)

  if alg.κ != nothing
    κ = alg.κ
  else
    κ = uEltypeNoUnits(1//100)
  end
  if alg.tol != nothing
    tol = alg.tol
  else
    tol = min(0.03,first(reltol)^(0.5))
  end

  tab = KenCarp5Tableau(real(uBottomEltypeNoUnits),real(tTypeNoUnits))

  ηold = one(uEltypeNoUnits)

  KenCarp5Cache{typeof(u),typeof(rate_prototype),typeof(atmp),typeof(J),typeof(uf),
              typeof(jac_config),uEltypeNoUnits,typeof(tab),typeof(linsolve),typeof(k1)}(
              u,uprev,du1,fsalfirst,k,z₁,z₂,z₃,z₄,z₅,z₆,z₇,z₈,
              k1,k2,k3,k4,k5,k6,k7,k8,
              dz,b,tmp,atmp,J,
              W,uf,jac_config,linsolve,ηold,κ,tol,10000,tab)
end
