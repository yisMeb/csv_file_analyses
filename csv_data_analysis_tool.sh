#!/bin/bash

# Get the CSV file name from the user
echo "Enter the name of the CSV file: "
read csv_file_name

if [ ! -f "$csv_file_name" ]; then
  echo "File $csv_file_name does not exist."
  exit 1
fi

file_extension="${csv_file_name##*.}"
if [[ "$file_extension" != "csv" ]]; then
  echo "The file is not of type CSV."
  exit 1
fi

# Define functions for each menu choice
function display_rows_and_columns() {
    num_columns=$(head -n 1 "$csv_file_name" | tr ',' '\n' | wc -l)

    # Count the number of rows (excluding the header)
    num_rows=$(tail -n +2 "$csv_file_name" | wc -l)

    echo "Number of columns: $num_columns"
    echo "Number of rows: $num_rows"
}

function list_unique_values() {
 echo "Enter column number: "
  read column_number

  unique=$(cut -d ',' -f "$column_number" "$csv_file_name" | sort | uniq)
  echo "The unique values in column $column_number are:"
  echo "$unique"
}

function display_column_names() {
  # Read the header row from the CSV file into an array
  #Internal Field Separator
  IFS=',' read -ra columns < "$csv_file_name"

  # Display the column names
  echo "The column names in '$csv_file_name' are:"
  for column_name in "${columns[@]}"; do
    echo "  $column_name"
  done
}

function minimum_maximum_values() {
  echo "The minimum and maximum values for numeric columns are:"
  #more logic here
  
}

function most_frequent_value() {

  display_column_names

  # Declare an associative array to store the most frequent values for each column
  declare -A most_frequent_values

  # Loop through the column names (which are now categorical columns)
  for column_name in "${column_names[@]}"; do
    # Find the column index based on the column name
    column_index=-1
    for i in "${!column_names[@]}"; do
      if [[ "${column_names[$i]}" == "$column_name" ]]; then
        column_index="$i"
        break
      fi
    done

    # Check if the column exists
    if [ "$column_index" -ne -1 ]; then
      # Use awk to find the most frequent value in the column
      most_frequent_value=$(tail -n +2 "$csv_file_name" | cut -d ',' -f "$((column_index + 1))" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
      most_frequent_values["$column_name"]=$most_frequent_value
    else
      echo "Column not found: $column_name"
    fi
  done

  # Display the most frequent values
  echo "The most frequent value for categorical columns are:"
  for column_name in "${column_names[@]}"; do
    echo "  $column_name: ${most_frequent_values[$column_name]}"
  done
}

function summary_statistics() {
  echo "The summary statistics for numeric columns are:"
  for column_name in "${numeric_columns[@]}"; do
    echo "  $column_name: mean = ${mean_values[$column_name]}, median = ${median_values[$column_name]}, standard deviation = ${standard_deviation_values[$column_name]}"
  done
}

function filtering_and_extracting() {
  echo "Enter the filtering condition: "
  read condition
}

function sorting() {
  echo "Enter the name of the column to sort: "
  read column_name
}

# Create a menu of options
menu_options=(
  "1.Display the number of rows and columns in the CSV file"
  "2.List unique values in a specified column"
  "3.Display column names (header)"
  "4.Minimum and maximum values for numeric columns"
  "5.The most frequent value for categorical columns"
  "6.Calculating summary statistics (mean, median, standard deviation) for numeric columns"
  "7.Filtering and extracting rows and column based on user-defined conditions"
  "8.Sorting the CSV file based on a specific column"
  "0.Exit"
)

# Display the menu
echo "Welcome to the CSV file analysis tool!"
echo "Please select one of the following options:"
for option in "${menu_options[@]}"; do
  echo "  ${option}"
done

# Get the user's choice
echo "Enter your choice: "
read choice

# Process the user's choice
while [[ $choice != 0 ]]; do
  # Call the corresponding function
  case $choice in
    "1")
      display_rows_and_columns
      ;;
    "2")
      list_unique_values
      ;;
    "3")
      display_column_names
      ;;
    "4")
      minimum_maximum_values
      ;;
    "5")
      most_frequent_value
      ;;
    "6")
      summary_statistics
      ;;
    "7")
      filtering_and_extracting
      ;;
    "8")
      sorting
      ;;
  esac

  # Display the menu again
  echo "Please select one of the following options:"
  for option in "${menu_options[@]}"; do
    echo "  ${option}"
  done

  # Get the user's choice
  echo "Enter your choice: "
  read choice
done

echo "Thank you for using the CSV file analysis tool!"
