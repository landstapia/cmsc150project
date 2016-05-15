maximize <- as.matrix(read.table("maximize.csv", header=FALSE, sep=","))
minimize <- t(maximize);

SimplexMethod <- function(matrix, verbose=FALSE){
    options(digits = 10);
    backup = matrix;
    iteration = 0;
    columns = ncol(matrix);
    rows = nrow(matrix);
    
    print(t(matrix));
    
    if(verbose) print(matrix);    
    
    while(TRUE) {
        iteration = iteration + 1;
        if(verbose) cat("Iteration ", iteration, "\n");
        
        # Selecting the pivot column
        pivotColumn = 1;
        while(matrix[rows, pivotColumn] > 0) pivotColumn = pivotColumn + 1;
        for(i in 1:(columns-1)){
            if(matrix[rows, i] < 0){
                if(abs(matrix[rows, pivotColumn]) <= abs(matrix[rows, i])){
                    pivotColumn = i;
                }
            }
        }
        if(verbose) cat("Pivot Column: ", pivotColumn, "\n");
        
        # Selecting the pivot row to select the pivot element
        pivotRow = 1;
        while((matrix[pivotRow, columns]/matrix[pivotRow, pivotColumn])<0) pivotRow = pivotRow + 1;
        for(i in 1:(rows-1)) {
            a = matrix[i, columns];
            b = matrix[i, pivotColumn];
            if(b>0) {
                test_ratio = a/b;
                cat("a: ", a, " b: ", b, " test ratio: ", test_ratio, "\n");
                if(test_ratio < (matrix[pivotRow, columns]/matrix[pivotRow, pivotColumn])){
                    pivotRow = i;
                }
            }
        }
        if(verbose) cat("Pivot Row: ", pivotRow, "\n");
        
        # Normalizing the pivot row
        multiplier = (1/matrix[pivotRow, pivotColumn]);
        for(j in 1:columns){
            matrix[pivotRow, j] = (matrix[pivotRow, j]*multiplier);
        }
        
        # Normalizing the other rows
        for(i in 1:rows){
            if(i != pivotRow){
                multiplier = matrix[i, pivotColumn];
                for(j in 1:columns){
                    matrix[i, j] = (matrix[i, j]-(matrix[pivotRow, j]*multiplier));
                }
            }
        }
        
        if(verbose) print(matrix);
        
        dir.create("iterations", showWarnings = FALSE);
        
        # Write iteration to the csv file
        filename = paste("iterations/iteration_", iteration, ".csv")
        write.csv(matrix, file = filename);
        
        # Check if the method should continue or not.
        check = 0;
        for(i in 1:columns){
            if(matrix[rows, i] < 0){
                check = 1;
                break;
            }
        }
        if(check == 0) break;
    }
    
    # Get the solutions from the matrix.
    for(i in 1:(columns-1)){
        check = 0;
        index = 0;
        for(j in 1:rows){
            if(matrix[j, i] == 1) index = j;
            if(matrix[j, i] > 1 || matrix[j,i] < 0) check = 1;
        }
        if(check != 1 && index > 0){
            if(verbose) cat("Answer on ", i, " is ", matrix[index, columns], "\n")
        }
    }
    return(matrix);
}
SimplexMethod(maximize, TRUE);