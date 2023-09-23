#!/bin/bash

#Declare global variables 
csv_file_name

open_file(){
# Get the CSV file name from the user
csv_file_name="$(whiptail --title "CSV Analyzer" --inputbox "Enter name of CSV File" 20 70 3>&1 1>&2 2>&3)"


if [ ! -f "$csv_file_name" ]; then
  whiptail --title "CSV Analyzer" --msgbox "File $csv_file_name does not exist." 20 70
  open_file
fi

file_extension="${csv_file_name##*.}"
if [[ "$file_extension" != "csv" ]]; then
  whiptail --title "CSV Analyzer" --msgbox "The file is not of type CSV." 20 70
  open_file
fi
}



# Function to display the menu
display_menu() {
  var=0
  var=$(whiptail --title "CSV Analyzer" --menu "9Choose Option" 20 100 10 \
  "1" "Display number of rows and columns" \
  "2" "List unique values in a column" \
  "3" "Display column names" \
  "4" "Calculate minimum and maximum values" \
  "5" "Find the most frequent value in a column" \
  "6" "Calculate summary statistics" \
  "7" "Filter and extract rows and columns" \
  "8" "Sort the CSV file" \
  "9" "Exit"  3>&1 1>&2 2>&3)

    if [ -z "$var" ]; then
        Exit
    else
    case $var in
        1)
            display_row_column_count
            ;;
        2)
            list_unique_values
            ;;
        3)
            display_column_names
            ;;
        4)
            calculate_min_max
            ;;
        5)
            find_most_frequent_value
            ;;
        6)
            calculate_summary_statistics
            ;;
        7)
            filter_extract_rows_columns
            ;;
        8)
            sort_csv_file
            ;;
        9)
            clear
            whiptail --title "CSV Analyzer" --msgbox "Goodbye!" 20 20
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
    fi
}
# Function to display the number of rows and columns
display_row_column_count() {
    clear
    row_count=$(wc -l < data.csv)
    column_count=$(head -1 data.csv | tr ',' '\n' | wc -l)
    echo "Number of rows: $row_count"
    echo "Number of columns: $column_count"
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to list unique values in a column
list_unique_values() {
    clear
    read -p "Enter the column name: " column_name
    unique_values=$(tail -n +2 data.csv | cut -d ',' -f "$(head -n 1 data.csv | tr ',' '\n' | grep -n "$column_name" | cut -d ':' -f 1)")
    echo "Unique values in $column_name:"
    echo "$unique_values" | sort -u
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to display column names
display_column_names() {
    clear
    column_names=$(head -n 1 data.csv | tr ',' '\n')
    echo "Column names:"
    echo "$column_names"
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to calculate minimum and maximum values
calculate_min_max() {
    clear
    read -p "Enter the column name: " column_name
    min_max_values=$(tail -n +2 data.csv | cut -d ',' -f "$(head -n 1 data.csv | tr ',' '\n' | grep -n "$column_name" | cut -d ':' -f 1)" | sort -n)
    min_value=$(echo "$min_max_values" | head -1)
    max_value=$(echo "$min_max_values" | tail -1)
    echo "Minimum value in $column_name: $min_value"
    echo "Maximum value in $column_name: $max_value"
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to find the most frequent value in a column
find_most_frequent_value() {
    clear
    read -p "Enter the column name: " column_name
    most_frequent_value=$(tail -n +2 data.csv | cut -d ',' -f "$(head -n 1 data.csv | tr ',' '\n' | grep -n "$column_name" | cut -d ':' -f 1)" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    echo "Most frequent value in $column_name: $most_frequent_value"
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to calculate summary statistics
calculate_summary_statistics() {
    clear
    read -p "Enter the column name for which you want to calculate summary statistics: " column_name

    # Extract values from the specified column without the header
    values=$(tail -n +2 data.csv | cut -d ',' -f "$(head -n 1 data.csv | tr ',' '\n' | grep -n "$column_name" | cut -d ':' -f 1)")
             #check if the value is number here
       # if (( $values =~'^[0-9]+$')); then
        # Calculate mean
        mean=$(echo "$values" | awk '{ sum += $1 } END { if (NR > 0) print sum / NR }')
        # Calculate median
        sorted_values=$(echo "$values" | tr ' ' '\n' | sort -n)
        num_values=$(echo "$sorted_values" | wc -l)
        median=""
        if ((num_values % 2 == 0)); then
            middle1=$(echo "$sorted_values" | sed -n "$((num_values / 2))p")
            middle2=$(echo "$sorted_values" | sed -n "$((num_values / 2 + 1))p")
            median=$(echo "scale=2;($middle1 + $middle2) / 2" | bc)
        else
            median=$(echo "$sorted_values" | sed -n "$((num_values / 2 + 1))p")
        fi
        # Calculate standard deviation
        mean_value=$(echo "$values" | awk '{ sum += $1 } END { if (NR > 0) print sum / NR }')
        variance=$(echo "$values" | awk -v mean="$mean_value" '{ sum += ($1 - mean)^2 } END { if (NR > 1) print sum / (NR - 1) }')
        standard_deviation=$(echo "sqrt($variance)" | bc)

        echo "Summary Statistics for $column_name:"
        echo "Mean: $mean"
        echo "Median: $median"
        echo "Standard Deviation: $standard_deviation"
       # else 
       # echo "not a numbered column"
       # fi
    echo
    read -p "Press enter to return to the menu" input
    display_menu
}

# Function to filter and extract rows and columns
filter_extract_rows_columns() {
    # Implement your logic to filter and extract rows and columns
    clear
    echo "Enter a search criteria:"
    read search_criteria
  # Extract the row from the CSV file based on the search criteria
    extracted_row=$(grep -n "$search_criteria" data.csv | cut -d ':' -f 1)
    whole_row=$(sed -n "$extracted_row"p data.csv)
  # Print the extracted row to the console

    # Split the whole row variable into columns
    columns=(${whole_row//,/ })

    # Print the column data in new lines
    for column in "${columns[@]}"; do
      echo "$column"
    done
    display_menu
}

#Function to sort the CSV file
sort_csv_file() {
    clear

        # Ask the user to sort using what column
        PS3="Select sorting column: "
        options=("First Name" "Last Name" "Date of Birth" "Cancel")
        select option in "${options[@]}"; do
            case $option in
                "First Name")
                    sort -t, -k"3" data.csv > temp_sorted_data.csv
                    ;;
                "Last Name")
                    sort -t, -k"4" data.csv > temp_sorted_data.csv
                    ;;
                "Date of Birth")
                    sort -t, -k"8" data.csv > temp_sorted_data.csv
                    ;;
                 "Cancel")
                    display_menu
                    ;;
                *)
                    echo "Invalid option. Please choose a valid sorting order."
                    ;;
            esac

            # if [ -n "$sort_order" ]; then
            #    temp_sorted_file="temp_sorted_data.csv"
            #    sort -t, -k"$column_name" data.csv > "$temp_sorted_file"
             
                #if the sorting process was successful
                if [ -s temp_sorted_data.csv ]; then
                    #backup the original data
                    #cp data.csv data_backup.csv
                    #mv temp_sorted_file data.csv
                    #rm temp_stored_data.csv
                    echo "CSV file sorted based on $option ."
                else
                    echo "Error: Sorting failed. The CSV file remains unchanged."
                fi

                break
           
        done

    echo
    read -p "Press enter to return to the menu" input
    display_menu
}
# Main program loop
    open_file
    display_menu
