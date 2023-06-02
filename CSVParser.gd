extends Node

func parseCSV(file_path: String) -> Array:
	var csv = []
	var file = FileAccess.open(file_path, FileAccess.READ)
	file = file.get_as_text()
	var lines = file.split("\r")
	for line in lines:
		var csv_rows = line.split(";")
		csv.append(csv_rows)
	csv.pop_back() #last line empty
	return csv
