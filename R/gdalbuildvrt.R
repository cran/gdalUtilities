##' This function provides an interface mirroring that of the GDAL
##' command-line app \code{gdalbuildvrt}. For a description of the
##' utility and the arguments that it takes, see the documentation at
##' \url{https://gdal.org/programs/gdalbuildvrt.html}.
##'
##' @title Interface to GDAL's gdalbuildvrt utility
##' @param gdalfile Character vector supplying file paths to one or
##'     more input datasets.
##' @param output.vrt Character. Path to output VRT file. Typically,
##'     output file will have suffix \code{".vrt"}.
##' @param ... Here, a placeholder argument that forces users to
##'     supply exact names of all subsequent formal arguments.
##' @param tileindex,resolution,te,tr,tap,separate,b,sd See the GDAL
##'     project's
##'     \href{https://gdal.org/programs/gdalbuildvrt.html}{gdalbuildvrt
##'     documentation} for details.
##' @param allow_projection_difference,q,optim,addalpha,hidenodata See
##'     the GDAL project's
##'     \href{https://gdal.org/programs/gdalbuildvrt.html}{gdalbuildvrt
##'     documentation} for details.
##' @param srcnodata,vrtnodata,ignore_srcmaskband,a_srs,r,oo See the
##'     GDAL project's
##'     \href{https://gdal.org/programs/gdalbuildvrt.html}{gdalbuildvrt
##'     documentation} for details.
##' @param input_file_list,strict,non_strict,overwrite See the GDAL
##'     project's
##'     \href{https://gdal.org/programs/gdalbuildvrt.html}{gdalbuildvrt
##'     documentation} for details.
##' @param dryrun Logical (default \code{FALSE}). If \code{TRUE},
##'     instead of executing the requested call to GDAL, the function
##'     will print the command-line call that would produce the
##'     equivalent output.
##' @param config_options A named character vector with GDAL config
##'     options, of the form \code{c(option1=value1, option2=value2)}. (See
##'     \href{https://gdal.org/user/configoptions.html}{here} for a
##'     complete list of supported config options.)
##' @return Silently returns path to \code{output.vrt}.
##' @export
##' @author Joshua O'Brien
##' @examples
##' ## Prepare file paths
##' td <- tempdir()
##' out_vrt <- file.path(td, "out.vrt")
##' layer1 <-
##'     system.file("extdata/tahoe_lidar_bareearth.tif",
##'                 package = "gdalUtilities")
##' layer2 <-
##'     system.file("extdata/tahoe_lidar_highesthit.tif",
##'                 package = "gdalUtilities")
##'
##' ## Build VRT and check that it works
##' gdalbuildvrt(gdalfile = c(layer1, layer2), output.vrt = out_vrt)
##' gdalinfo(out_vrt)
gdalbuildvrt <-
    function(gdalfile, output.vrt, ..., tileindex, resolution, te, tr,
             tap, separate, b, sd, allow_projection_difference, optim,
             q, addalpha, hidenodata, srcnodata, vrtnodata,
             ignore_srcmaskband, a_srs, r, oo, input_file_list,
             strict, non_strict, overwrite,
             config_options = character(0), dryrun = FALSE)
{
    ## Unlike `as.list(match.call())`, forces eval of arguments
    args <-  mget(names(match.call())[-1])
    args[c("gdalfile", "output.vrt", "config_options", "dryrun")] <- NULL
    formalsTable <- getFormalsTable("gdalbuildvrt")
    opts <- process_args(args, formalsTable)

    if(dryrun) {
        ## Pass everything through opts to enforce order expected by
        ## command-line utility
        x <- CLI_call("gdalbuildvrt", opts = c(opts, output.vrt, gdalfile))
        return(x)
    }

    gdal_utils("buildvrt",
               source = gdalfile,
               destination = output.vrt,
               options = opts,
               config_options = config_options)
    invisible(output.vrt)
}
