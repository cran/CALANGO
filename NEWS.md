# CALANGO 1.0.20

- Regular maintenance update:  
    - Minor bug fix that resulted in occasional errors on Windows machines  
    - Minor updates to documentation
    - Minor tweak to dependencies
    - Fixed problem that resulted in `retrieve_calanguize_genomes()` wiping out 
    the target folder

# CALANGO 1.0.14

- Regular maintenance update:
    - Updated documentation, added links to published paper.

# CALANGO 1.0.13

- Regular maintenance update:
    - Fixed Vignette listing. Added examples page as a full vignette.

# CALANGO 1.0.12

- Regular maintenance update:
    
    - Added a second set of examples under Vignette "Usage Examples".
    - Updated project home page, minor updates to documentation.
    - Minor changes to Rmd files to prevent pandoc errors.

# CALANGO 1.0.10

- Regular maintenance update:
    
    - Updated project home page, minor updates to documentation.

# CALANGO 1.0.8

- Regular maintenance update:

    - Minor internal changes to ensure compatibility with dendextend v1.15.2.
    - Changed naming standard of report plots to increase Windows compatibility:
      file names of correlation plots and boxplots now use "_" rather than ":".

# CALANGO 1.0.5

- Regular maintenance update:

    - Tested compatibility with taxize v1.0: OK
    - Added function *retrieve_calanguize_genomes()* to enable users to quickly 
    retrieve the *calanguize_genomes* Perl script, which is useful for preparing 
    data to be used with CALANGO
    - Removed input attribute `url` from function *retrieve_data_files()*. This 
    does not break existing code - if `url` is passed it will just be ignored.
    - Updated package logo in all documentation.


# CALANGO 1.0.2

- Initial CRAN release: Provides a small number of user-facing functions to:

    - Perform sophisticated association analyses between annotation terms and quantitative genotypes/phenotypes
    - Generate a full analysis website containing that can be easily shared with collaborators or the wider research community.
