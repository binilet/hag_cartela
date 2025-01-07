import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../States/cartelas_state.dart';

class JackpotBoards extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final provider = Provider.of<CartelasProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter Board ID',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.grid_4x4_rounded,
                        color: Colors.blue[400],
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          // Clear text field
                          // Note: You'll need to add a controller to implement this
                          // controller.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: 'Type board ID number...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      final boardId = int.tryParse(value);
                      if (boardId != null) {
                        provider.addBoard(boardId);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: provider.loadBoardsFromServer,
                  icon: const Icon(
                    Icons.cloud_download_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'Load',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: provider.selectedBoards.map((board) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate responsive sizes based on screen width
                      final isSmallScreen = constraints.maxWidth < 600;
                      final isMediumScreen = constraints.maxWidth < 900;

                      // Adjust board width based on screen size
                      double width = provider.selectedBoards.length == 1
                          ? constraints.maxWidth
                          : isSmallScreen
                          ? constraints.maxWidth // Full width on small screens
                          : (constraints.maxWidth / 2) - 16;

                      // Calculate cell size to ensure proper spacing
                      double cellSize = isSmallScreen
                          ? (width - 32 - (4 * 8)) / 5 // Account for padding and gaps
                          : isMediumScreen
                          ? 52
                          : 64;

                      // Adjust font sizes based on cell size
                      double numberFontSize = isSmallScreen ? 16 : 18;
                      double bingoLetterSize = isSmallScreen ? 20 : 24;
                      double boardNameSize = isSmallScreen ? 18 : 20;

                      return Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: width,
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Board Name with responsive sizing
                              Text(
                                board.boardName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: boardNameSize,
                                  color: const Color(0xFF2C3E50),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              // BINGO Header with adjusted spacing
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 6.0 : 8.0,
                                  horizontal: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('B', style: TextStyle(color: const Color(0xFFE74C3C), fontSize: bingoLetterSize, fontWeight: FontWeight.bold)),
                                    Text('I', style: TextStyle(color: const Color(0xFF3498DB), fontSize: bingoLetterSize, fontWeight: FontWeight.bold)),
                                    Text('N', style: TextStyle(color: const Color(0xFF2ECC71), fontSize: bingoLetterSize, fontWeight: FontWeight.bold)),
                                    Text('G', style: TextStyle(color: const Color(0xFFF1C40F), fontSize: bingoLetterSize, fontWeight: FontWeight.bold)),
                                    Text('O', style: TextStyle(color: const Color(0xFF9B59B6), fontSize: bingoLetterSize, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              // Responsive Bingo Grid
                              SizedBox(
                                height: cellSize * 5 + (4 * 8), // Total height for grid
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                    childAspectRatio: 1, // Keep cells square
                                  ),
                                  itemCount: 25,
                                  itemBuilder: (context, index) {
                                    final row = index ~/ 5;
                                    final col = index % 5;
                                    final isCenterCell = row == 2 && col == 2;

                                    return GestureDetector(
                                      onTap: () => provider.toggleCell(board.boardId, row, col),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isCenterCell
                                              ? const Color(0xFFE8F5E9)
                                              : provider.isCellSelected(board.boardId, row, col)
                                              ? const Color(0xFF90CAF9)
                                              : Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFFBDBDBD),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: isCenterCell
                                            ? Icon(
                                          Icons.star_rounded,
                                          color: const Color(0xFF66BB6A),
                                          size: isSmallScreen ? 24 : 28,
                                        )
                                            : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              board.boardNumbers[row][col].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: numberFontSize,
                                                color: provider.isCellSelected(board.boardId, row, col)
                                                    ? const Color(0xFF1565C0)
                                                    : const Color(0xFF424242),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              // Delete Button
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () => provider.removeBoard(board.boardId),
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: const Color(0xFFE53935),
                                    size: isSmallScreen ? 24 : 28,
                                  ),
                                  tooltip: 'Remove Board',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        )
        ,
        if(provider.availableBoards.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Boards Available ${provider.availableBoards.length}')
          )
      ],
    );
  }
}