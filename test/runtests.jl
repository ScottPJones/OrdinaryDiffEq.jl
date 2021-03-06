using OrdinaryDiffEq, DiffEqProblemLibrary, DiffEqDevTools
using Base.Test

const CPU_FLOPS = peakflops()
const LONGER_TESTS = false

const CACHE_TEST_ALGS = [Euler(),Midpoint(),RK4(),SSPRK22(),SSPRK33(),SSPRK53(),
  SSPRK63(),SSPRK73(),SSPRK83(),SSPRK432(),SSPRK932(),SSPRK54(),SSPRK104(),CarpenterKennedy2N54(),
  BS3(),BS5(),DP5(),DP5Threaded(),DP8(),Feagin10(),Feagin12(),Feagin14(),TanYam7(),
  Tsit5(),TsitPap8(),Vern6(),Vern7(),Vern8(),Vern9(),OwrenZen3(),OwrenZen4(),OwrenZen5()]

#Start Test Script

tic()
@time @testset "Discrete Tests" begin include("discrete_algorithm_test.jl") end
@time @testset "Linear Tests" begin include("ode/ode_twodimlinear_tests.jl") end
@time @testset "Convergence Tests" begin include("ode/ode_convergence_tests.jl") end
@time @testset "Adaptive Tests" begin include("ode/ode_adaptive_tests.jl") end
@time @testset "Tstops Tests" begin include("ode/ode_tstops_tests.jl") end
@time @testset "Backwards Tests" begin include("ode/ode_backwards_test.jl") end
@time @testset "Reinit Tests" begin include("reinit_test.jl") end
@time @testset "Initial Dt Tests" begin include("ode/ode_initdt_tests.jl") end
@time @testset "OwrenZen Tests" begin include("owrenzen_tests.jl") end
@time @testset "Rosenbrock Tests" begin include("ode/ode_rosenbrock_tests.jl") end
@time @testset "Mass Matrix Tests" begin include("mass_matrix_tests.jl") end
@time @testset "Differentiation Trait Tests" begin include("differentiation_traits_tests.jl") end
@time @testset "Partitioned Methods Tests" begin include("partitioned_methods_tests.jl") end
@time @testset "Split Methods Tests" begin include("split_methods_tests.jl") end
#@time @testset "Linear Methods Tests" begin include("linear_method_tests.jl") end
#@time @testset "Linear-Nonlinear Methods Tests" begin include("linear_nonlinear_convergence_tests.jl") end
@time @testset "SSPRK Tests" begin include("ode/ode_ssprk_tests.jl") end
@time @testset "Dense Tests" begin include("ode/ode_dense_tests.jl") end
@time @testset "In-Place Tests" begin include("ode/ode_inplace_tests.jl") end
@time @testset "Time Derivative Tests" begin include("time_derivative_test.jl") end
@time @testset "Events Tests" begin include("ode/ode_event_tests.jl") end
@time @testset "Cache Tests" begin include("ode/ode_cache_tests.jl") end
@time @testset "saveat Tests" begin include("ode/ode_saveat_tests.jl") end
@time @testset "save_idxs Tests" begin include("ode/ode_saveidxs_tests.jl") end

@time @testset "Number Type Tests" begin include("ode/ode_numbertype_tests.jl") end
@time @testset "Static Array Tests" begin include("static_array_tests.jl") end
@time @testset "Data Array Tests" begin include("data_array_test.jl") end
@time @testset "Ndim Complex Tests" begin include("ode/ode_ndim_complex_tests.jl") end
@time @testset "Iterator Tests" begin include("iterator_tests.jl") end
@time @testset "u_modifed Tests" begin include("umodified_test.jl") end
@time @testset "Composite Algorithm Tests" begin include("composite_algorithm_test.jl") end

toc()
