import EnergyExpressions: QuantumOperator, NBodyTermFactor, NBodyTerm,
    OrbitalMatrixElement, NBodyMatrixElement
import AngularMomentumAlgebra: radial_integral

function ref_exchange_multipoles(a, b)
    # Table 1⁶ of Condon & Shortley. As noted by in ref [10] of
    #
    # - Cohl, H. S., Rau, A. R. P., Tohline, J. E., Browne, D. A., Cazes,
    #   J. E., & Barnes, E. I. (2001). Useful alternative to the multipole
    #   expansion of1/rpotentials. Physical Review A, 64(5),
    #   052509. http://dx.doi.org/10.1103/physreva.64.052509
    #
    # df, k = 5 is in error, and the numerator has to multiplied by 5
    # and the denominator replaced by 7623.
    reference = Dict((o"ks", o"kp") => ((1, 3, Dict((0,1) => 1,
                                                    (0,0) => 1)),),
                     (o"ks", o"kf") => ((3, 7, Dict((0,3) => 1,
                                                    (0,2) => 1,
                                                    (0,1) => 1,
                                                    (0,0) => 1)),),
                     (o"kp", o"kd") => ((1, 15, Dict((1,2) => 6,
                                                     (1,1) => 3,
                                                     (1,0) => 1,
                                                     (0,2) => 0,
                                                     (0,1) => 3,
                                                     (0,0) => 4,
                                                     (1,-2) => 0,
                                                     (1,-1) => 0)),
                                        (3, 245, Dict((1,2) => 3,
                                                      (1,1) => 9,
                                                      (1,0) => 18,
                                                      (0,2) => 15,
                                                      (0,1) => 24,
                                                      (0,0) => 27,
                                                      (1,-2) => 45,
                                                      (1,-1) => 30))),
                     (o"kd", o"kf") => ((1, 35, Dict((2,3) => 15,
                                                     (2,2) => 5,
                                                     (2,1) => 1,
                                                     (2,0) => 0,
                                                     (1,3) => 0,
                                                     (1,2) => 10,
                                                     (1,1) => 8,
                                                     (1,0) => 3,
                                                     (0,3) => 0,
                                                     (0,2) => 0,
                                                     (0,1) => 6,
                                                     (0,0) => 9,
                                                     (2,-3) => 0,
                                                     (2,-2) => 0,
                                                     (2,-1) => 0,
                                                     (1,-3) => 0,
                                                     (1,-2) => 0,
                                                     (1,-1) => 0)),
                                        (3, 315, Dict((2,3) => 10,
                                                      (2,2) => 20,
                                                      (2,1) => 24,
                                                      (2,0) => 20,
                                                      (1,3) => 25,
                                                      (1,2) => 15,
                                                      (1,1) => 2,
                                                      (1,0) => 2,
                                                      (0,3) => 25,
                                                      (0,2) => 0,
                                                      (0,1) => 9,
                                                      (0,0) => 16,
                                                      (2,-3) => 0,
                                                      (2,-2) => 0,
                                                      (2,-1) => 10,
                                                      (1,-3) => 0,
                                                      (1,-2) => 25,
                                                      (1,-1) => 15)),
                                        (5, 7623, Dict((2,3) => 5,
                                                       (2,2) => 25,
                                                       (2,1) => 75,
                                                       (2,0) => 175,
                                                       (1,3) => 35,
                                                       (1,2) => 120,
                                                       (1,1) => 250,
                                                       (1,0) => 400,
                                                       (0,3) => 140,
                                                       (0,2) => 315,
                                                       (0,1) => 450,
                                                       (0,0) => 500,
                                                       (2,-3) => 1050,
                                                       (2,-2) => 630,
                                                       (2,-1) => 350,
                                                       (1,-3) => 420,
                                                       (1,-2) => 560,
                                                       (1,-1) => 525))),
                     (o"ks", o"ks") => ((0, 1, Dict((0,0) => 1)),),
                     (o"ks", o"kd") => ((2, 5, Dict((0,2) => 1,
                                                    (0,1) => 1,
                                                    (0,0) => 1)),),
                     (o"kp", o"kp") => ((0, 1, Dict((1,1) => 1,
                                                    (1,0) => 0,
                                                    (0,0) => 1,
                                                    (1,-1) => 0)),
                                        (2, 25, Dict((1,1) => 1,
                                                     (1,0) => 3,
                                                     (0,0) => 4,
                                                     (1,-1) => 6))),
                     (o"kp", o"kf") => ((2, 175, Dict((1,3) => 45,
                                                      (1,2) => 30,
                                                      (1,1) => 18,
                                                      (1,0) => 9,
                                                      (0,3) => 0,
                                                      (0,2) => 15,
                                                      (0,1) => 24,
                                                      (0,0) => 27,
                                                      (1,-3) => 0,
                                                      (1,-2) => 0,
                                                      (1,-1) => 3)),
                                        (4, 189, Dict((1,3) => 1,
                                                      (1,2) => 3,
                                                      (1,1) => 6,
                                                      (1,0) => 10,
                                                      (0,3) => 7,
                                                      (0,2) => 12,
                                                      (0,1) => 15,
                                                      (0,0) => 16,
                                                      (1,-3) => 28,
                                                      (1,-2) => 21,
                                                      (1,-1) => 15))),
                     (o"kd", o"kd") => ((0, 1, Dict((2,2) => 1,
                                                    (2,1) => 0,
                                                    (2,0) => 0,
                                                    (1,1) => 1,
                                                    (1,0) => 0,
                                                    (0,0) => 1,
                                                    (2,-2) => 0,
                                                    (2,-1) => 0,
                                                    (1,-1) => 0)),
                                        (2, 49, Dict((2,2) => 4,
                                                     (2,1) => 6,
                                                     (2,0) => 4,
                                                     (1,1) => 1,
                                                     (1,0) => 1,
                                                     (0,0) => 4,
                                                     (2,-2) => 0,
                                                     (2,-1) => 0,
                                                     (1,-1) => 6)),
                                        (4, 441, Dict((2,2) => 1,
                                                      (2,1) => 5,
                                                      (2,0) => 15,
                                                      (1,1) => 16,
                                                      (1,0) => 30,
                                                      (0,0) => 36,
                                                      (2,-2) => 70,
                                                      (2,-1) => 35,
                                                      (1,-1) => 40))),
                     (o"kf", o"kf") => ((0, 1, Dict((3,3) => 1,
                                                    (3,2) => 0,
                                                    (3,1) => 0,
                                                    (3,0) => 0,
                                                    (2,2) => 1,
                                                    (2,1) => 0,
                                                    (2,0) => 0,
                                                    (1,1) => 1,
                                                    (1,0) => 0,
                                                    (0,0) => 1,
                                                    (3,-3) => 0,
                                                    (3,-2) => 0,
                                                    (3,-1) => 0,
                                                    (2,-2) => 0,
                                                    (2,-1) => 0,
                                                    (1,-1) => 0)),
                                        (2, 225, Dict((3,3) => 25,
                                                      (3,2) => 25,
                                                      (3,1) => 10,
                                                      (3,0) => 0,
                                                      (2,2) => 0,
                                                      (2,1) => 15,
                                                      (2,0) => 20,
                                                      (1,1) => 9,
                                                      (1,0) => 2,
                                                      (0,0) => 16,
                                                      (3,-3) => 0,
                                                      (3,-2) => 0,
                                                      (3,-1) => 0,
                                                      (2,-2) => 0,
                                                      (2,-1) => 0,
                                                      (1,-1) => 24)),
                                        (4, 1089, Dict((3,3) => 9,
                                                       (3,2) => 30,
                                                       (3,1) => 54,
                                                       (3,0) => 63,
                                                       (2,2) => 49,
                                                       (2,1) => 32,
                                                       (2,0) => 3,
                                                       (1,1) => 1,
                                                       (1,0) => 15,
                                                       (0,0) => 36,
                                                       (3,-3) => 0,
                                                       (3,-2) => 0,
                                                       (3,-1) => 42,
                                                       (2,-2) => 70,
                                                       (2,-1) => 14,
                                                       (1,-1) => 40)),
                                        (6, 7361*64, Dict((3,3) => 1,
                                                          (3,2) => 7,
                                                          (3,1) => 28,
                                                          (3,0) => 84,
                                                          (2,2) => 36,
                                                          (2,1) => 105,
                                                          (2,0) => 224,
                                                          (1,1) => 225,
                                                          (1,0) => 350,
                                                          (0,0) => 400,
                                                          (3,-3) => 924,
                                                          (3,-2) => 462,
                                                          (3,-1) => 210,
                                                          (2,-2) => 504,
                                                          (2,-1) => 378,
                                                          (1,-1) => 420))))

    g = CoulombInteraction()
    terms = NBodyTerm[]

    push_multipole!(k, coeff) =
        push!(terms, NBodyTerm([radial_integral([a,b], (k,g), [b,a])], coeff))

    ao,bo = Orbital(:k, a.orb.ℓ),Orbital(:k, b.orb.ℓ)
    i,j = ao ≤ bo ? (1,2) : (2,1)
    uv = (ao,bo)[[i,j]]

    m′,m = (a.m[1],b.m[1])[[i,j]]
    ao == bo && abs(m) > abs(m′) && ((m′,m) = (m,m′))
    # The table only stores the upper sign of the projection quantum
    # numbers, since the opposite signs have the same values.
    if iszero(m′)
        m = abs(m)
    else
        m *= sign(m′)
    end
    m′ = abs(m′)

    for (k,D,Ns) in reference[uv]
        N = Ns[(m′,m)]
        iszero(N) && continue
        push_multipole!(k, N/D)
    end

    NBodyMatrixElement(terms)
end

function ref_direct_multipoles(a, b)
    # Table 2⁶ of Condon & Shortley
    reference = Dict((o"kp", o"kp") => ((2, 25, Dict((1,1) => 1,
                                                     (1,0) => -2,
                                                     (0,0) => 4)),),
                     (o"kp", o"kd") => ((2, 35, Dict((1,2) => 2,
                                                     (1,1) => -1,
                                                     (1,0) => -2,
                                                     (0,2) => -4,
                                                     (0,1) => 2,
                                                     (0,0) => 4)),),
                     (o"kp", o"kf") => ((2, 75, Dict((1,3) => 5,
                                                     (1,2) => 0,
                                                     (1,1) => -3,
                                                     (1,0) => -4,
                                                     (0,3) => -10,
                                                     (0,2) => 0,
                                                     (0,1) => 6,
                                                     (0,0) => 8)),),
                     (o"kd", o"kd") => ((2, 49, Dict((2,2) => 4,
                                                     (2,1) => -2,
                                                     (2,0) => -4,
                                                     (1,1) => 1,
                                                     (1,0) => 2,
                                                     (0,0) => 4)),
                                        (4, 441, Dict((2,2) => 1,
                                                      (2,1) => -4,
                                                      (2,0) => 6,
                                                      (1,1) => 16,
                                                      (1,0) => -24,
                                                      (0,0) => 36))),
                     (o"kd", o"kf") => ((2, 105, Dict((2,3) => 10,
                                                      (2,2) => 0,
                                                      (2,1) => -6,
                                                      (2,0) => -8,
                                                      (1,3) => -5,
                                                      (1,2) => 0,
                                                      (1,1) => 3,
                                                      (1,0) => 4,
                                                      (0,3) => -10,
                                                      (0,2) => 0,
                                                      (0,1) => 6,
                                                      (0,0) => 8)),
                                        (4, 693, Dict((2,3) => 3,
                                                      (2,2) => -7,
                                                      (2,1) => 1,
                                                      (2,0) => 6,
                                                      (1,3) => -12,
                                                      (1,2) => 28,
                                                      (1,1) => -4,
                                                      (1,0) => -24,
                                                      (0,3) => 18,
                                                      (0,2) => -42,
                                                      (0,1) => 6,
                                                      (0,0) => 36))),
                     (o"kf", o"kf") => ((2, 225, Dict((3,3) => 25,
                                                      (3,2) => 0,
                                                      (3,1) => -15,
                                                      (3,0) => -20,
                                                      (2,2) => 0,
                                                      (2,1) => 0,
                                                      (2,0) => 0,
                                                      (1,1) => 9,
                                                      (1,0) => 12,
                                                      (0,0) => 16)),
                                        (4, 1089, Dict((3,3) => 9,
                                                       (3,2) => -21,
                                                       (3,1) => 3,
                                                       (3,0) => 18,
                                                       (2,2) => 49,
                                                       (2,1) => -7,
                                                       (2,0) => -42,
                                                       (1,1) => 1,
                                                       (1,0) => 6,
                                                       (0,0) => 36)),
                                        (6, 7361*64, Dict((3,3) => 1,
                                                          (3,2) => -6,
                                                          (3,1) => 15,
                                                          (3,0) => -20,
                                                          (2,2) => 36,
                                                          (2,1) => -90,
                                                          (2,0) => 120,
                                                          (1,1) => 225,
                                                          (1,0) => -300,
                                                          (0,0) => -400))))

    g = CoulombInteraction()
    terms = NBodyTerm[]

    push_multipole!(k, coeff) =
        push!(terms, NBodyTerm([radial_integral([a,b], (k,g), [a,b])], coeff))

    # The monopole is always present in the multipole expansion of the
    # direct interaction.
    push_multipole!(0, 1.0)

    ao,bo = Orbital(:k, a.orb.ℓ),Orbital(:k, b.orb.ℓ)
    i,j = ao ≤ bo ? (1,2) : (2,1)
    uv = (ao,bo)[[i,j]]
    if uv ∈ keys(reference)
        ref = reference[uv]

        m′m = (abs(a.m[1]), abs(b.m[1]))
        m′,m = uv[1] < uv[2] ? m′m[[i,j]] : reverse(minmax(m′m...))

        for (k,D,Ns) in ref
            N = Ns[(m′,m)]
            iszero(N) && continue
            push_multipole!(k, N/D)
        end
    end

    NBodyMatrixElement(terms)
end
