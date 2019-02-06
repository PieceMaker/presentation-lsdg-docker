#' Simple example simulation for use in demonstrating rminions package.
#'
#' @import copula
#' @export
stealTheMoonSim <- function(fuelParams, solarFlareParams, flareSurfaceParams, flareAdditionalFuelParams,
    surfaceFuelDependenceCopParams, asteroidParams, asteroidAdditionalFuelParams) {
    surfaceFuelDependenceCop <- copula::claytonCopula(surfaceFuelDependenceCopParams$param, dim = 2)

    baseFuel <- rlnorm(1, meanlog = fuelParams$meanlog, sdlog = fuelParams$sdlog)

    # Solar flares occurring during trip
    numSolarFlares <- rpois(1, lambda = solarFlareParams$lambda)
    flareSurface <- rgamma(numSolarFlares, shape = flareSurfaceParams$shape, scale = flareSurfaceParams$scale)
    flareSurfaceUnif <- pgamma(flareSurface, shape = flareSurfaceParams$shape, scale = flareSurfaceParams$scale)
    flareAdditionalFuelUnif <- copula::cCopula(
        u = as.matrix(
            cbind(
                flareSurfaceUnif,
                runif(numSolarFlares)
            )
        ),
        cop = surfaceFuelDependenceCop,
        indices = 2,
        inverse = T
    )
    # Additional required fuel due to solar flares, converted to millions of pounds
    flareAdditionalFuel <- qlnorm(flareAdditionalFuelUnif, meanlog = flareAdditionalFuelParams$meanlog, sdlog = flareAdditionalFuelParams$sdlog)/10

    # Asteroids along path
    asteroidsOnPath <- rpois(10000000, lambda = asteroidParams$lambda)
    asteroidSegments <- which(asteroidsOnPath > 0)
    numAsteroids <- sum(asteroidsOnPath)
    # Additional required fuel due to dodging asteroids, converted to millions of pounds
    asteroidAdditionalFuel <- rnorm(numAsteroids, mean = asteroidAdditionalFuelParams$mean, sd = asteroidAdditionalFuelParams$sd) / 10000

    totalFuel <- baseFuel + sum(flareAdditionalFuel) + sum(asteroidAdditionalFuel)

    response <- list(
        numSolarFlares = numSolarFlares,
        flareSurface = flareSurface,
        baseFuel = baseFuel,
        flareAdditionalFuel = flareAdditionalFuel,
        asteroidSegments = asteroidSegments,
        asteroidsPerSegment = asteroidsOnPath[asteroidSegments],
        asteroidAdditionalFuel = asteroidAdditionalFuel,
        totalFuel = totalFuel
    )
    return(response)
}
