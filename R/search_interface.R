
# Search function to take user input and return
# the relevant dataset(s) from the data.gov.au
# repository


# oz_metadata  tibble file



# Data from user:
# re-import metadata?
# search keywords, organisation, name, id

# maintainer, num_tags, id, author, author_email, state, contact_point,
# resources, tags, groups, organization, name, url, notes, owner_org,
# data_state, title, contact_info

ozdata_usr_srch <- function(){
    require(ckanr)

    # Set up ckanr link to data.gov.au
    ckanr_setup(url="http://data.gov.au/")

    # Perform check for existing oz_metadata file
    # [insert code for this check]

    # Perform update check. Does existing metadata file need updating
    # Look at date modfied of local file
    # Pull out most recent change to ckanr data.
    changes(limit = 2, as = "table")[, 1:4]


    # create temporary files and directories
    tmp_file <- tempfile()
    tmp_dir <- file.path(tempdir(), basename(tempfile()))
    dir.create(tmp_dir, showWarnings = FALSE, recursive = TRUE)

    if(oz_meta_check = NULL){download_oz_metadata()}
    # Ask user if they want to download the lastest metadata (returns integere 1 for Yes or 2 for No)
    dl_meta <- menu(c("Yes", "No"), title = "Do you want to download the latest data.gov.au metadata?")
    # Download
    if(dl_meta == 1) {download_oz_metadata()}
    search_term <- readline(prompt = "Enter your keyword search term: ")
    print("Do you want to search by group name, tag or keyword?")
    ?readline()



}  # end 'ozdata_user_input

