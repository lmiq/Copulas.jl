
@testitem "Test of coherence for archimedeans" begin

    # This test checks that 

    using HypothesisTests, Distributions, Random
    Random.seed!(123)
    cops = (
        # true represent the fact that cdf(williamson_dist(C),x) is defined or not. 
        (AMHCopula(3,0.6), true),
        (AMHCopula(4,-0.3), true),
        (ClaytonCopula(2,-0.7), true),
        (ClaytonCopula(3,-0.1), true),
        (ClaytonCopula(4,7), true),
        (FrankCopula(2,-5), false),
        (FrankCopula(3,12), false),
        (FrankCopula(4,6), false),
        (FrankCopula(4,30), false),
        (FrankCopula(4,37), false),
        (FrankCopula(4,150), false),
        (JoeCopula(3,7), false),
        (GumbelCopula(4,7), false),
        (GumbelBarnettCopula(3,0.7),true),
        (InvGaussianCopula(4,0.05),true),
        (InvGaussianCopula(3,8),true)
    )
    n = 1000
    spl = rand(n)
    spl2 = rand(n)
    for (C,cdf_implemented) in cops
        @show C
        spl .= dropdims(sum(Copulas.ϕ⁻¹.(Ref(C),rand(C,n)),dims=1),dims=1)
        W = Copulas.williamson_dist(C)
        if cdf_implemented
            pval = pvalue(ExactOneSampleKSTest(spl, W),tail=:right)
            @test pval > 0.01
        end
        # even without a cdf we can still test approximately:
        spl2 .= rand(W,n)
        pval2 = pvalue(ApproximateTwoSampleKSTest(spl,spl2),tail=:right)
        @test pval2 > 0.01
    end

end