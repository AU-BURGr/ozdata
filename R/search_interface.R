
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

Y <- function(){
    # Perform check for existing oz_metadata file
    # [insert code for this check]

    # Ask user if they want to download the lastest metadata (returns integere 1 for Yes or 2 for No)
    dl_meta <- menu(c("Yes", "No"), title = "Do you want to download the latest data.gov.au metadata?")

    if(dl_meta == 1, download_oz_metadata)
    search_term <- readline(prompt = "Enter your keyword search term: ")
    ?readline()
library(shiny)

# response <- utils::menu(c("Yes", "No"), title="Do you want this?", graphics = TRUE)

# Input keyword
?menu

}  # end 'ozdata_user_input

