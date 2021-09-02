# CALANGO 1.0.5

- Regular maintenance update:

    - Tested compatibility with taxize v1.0: OK
    - Added function *retrieve_calanguize_genomes()* to enagle users to quickly 
    retrieve the *calanguize_genomes* Perl script, which is useful for preparing 
    data to be used with CALANGO
    - Removed input attribute `url` from function *retrieve_data_files()*. This 
    does not break existing code - if `url` is passed it will just be ignored.
    - Updated package logo in all documentation.


# CALANGO 1.0.2

- Initial CRAN release: Provides a small number of user-facing functions to:

    - Perform sophisticated association analyses between annotation terms and quantitative genotypes/phenotypes
    - Generate a full analysis website containing that can be easily shared with collaborators or the wider research community.
