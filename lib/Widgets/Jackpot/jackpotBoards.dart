import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../States/cartelas_state.dart';

class JackpotBoards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartelasProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter Board ID',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.grid_4x4_rounded,
                        color: Colors.blue[400],
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          // Clear text field
                          // Note: You'll need to add a controller to implement this
                          // controller.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: 'Type board ID...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
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
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: provider.loadBoardsFromServer,
                  icon: const Icon(
                    Icons.cloud_download_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Load',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: provider.selectedBoards.map((board) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate responsive sizes based on screen width
                      final isSmallScreen = constraints.maxWidth < 600;
                      final isMediumScreen = constraints.maxWidth < 900;

                      // Adjust board width based on screen size
                      double width;
                      if (provider.selectedBoards.length > 1) {
                        width = (constraints.maxWidth / 2) - 4;
                      } else {
                        width = isSmallScreen
                            ? constraints.maxWidth
                            : (constraints.maxWidth / 2) - 8;
                      }

                      // Calculate cell size to ensure proper spacing
                      double cellSize = isSmallScreen
                          ? (width - 20 - (4 * 4)) / 5
                          : isMediumScreen
                          ? 44
                          : 52;

                      // Adjust font sizes based on cell size
                      double numberFontSize = isSmallScreen ? 12 : 14;
                      double bingoLetterSize = isSmallScreen ? 16 : 18;

                      return SizedBox( // Wrap with SizedBox to enforce width when in a row
                        width: width,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding( // Removed Container and using Padding directly
                            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: isSmallScreen ? 0 : 2), // Slight spacing adjustment
                                // BINGO Header with adjusted spacing
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 3.0 : 4.0,
                                    horizontal: 1.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(5.0),
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
                                SizedBox(height: isSmallScreen ? 8 : 10),
                                // Responsive Bingo Grid
                                SizedBox(
                                  height: cellSize * 5 + (4 * 4),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                      childAspectRatio: 1,
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
                                                ? const Color(0xFFBBDEFB)
                                                : Colors.white,
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                              width: 0.8,
                                            ),
                                            borderRadius: BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.03),
                                                blurRadius: 1,
                                                offset: const Offset(0, 0.5),
                                              ),
                                            ],
                                          ),
                                          child: isCenterCell
                                              ? Icon(
                                            Icons.star_rounded,
                                            color: const Color(0xFF66BB6A),
                                            size: isSmallScreen ? 18 : 20,
                                          )
                                              : FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.5),
                                              child: Text(
                                                board.boardNumbers[col][row].toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: numberFontSize,
                                                  color: provider.isCellSelected(board.boardId, row, col)
                                                      ? const Color(0xFF1976D2)
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                // Delete Button and Board ID
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Always show Board ID
                                      Text(
                                        '#${board.boardId}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold, // Made the board ID bolder
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () => provider.removeBoard(board.boardId),
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: const Color(0xFFE53935),
                                          size: isSmallScreen ? 18 : 20,
                                        ),
                                        tooltip: 'Remove Board',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        if (provider.availableBoards.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              'Total Boards Available: ${provider.availableBoards.length}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }
}