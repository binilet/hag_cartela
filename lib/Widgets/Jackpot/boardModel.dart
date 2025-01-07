class Board {
  final int boardId;
  final String boardName;
  final List<List<int>> boardNumbers;
  final String companyId;
  final String branchId;
  final bool isActive;
  final bool isReserved;

  Board({
    required this.boardId,
    required this.boardName,
    required this.boardNumbers,
    required this.companyId,
    required this.branchId,
    required this.isActive,
    required this.isReserved,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      boardId: json['board_id'],
      boardName: json['board_name'] ?? '',
      boardNumbers: List<List<int>>.from(
          json['board_numbers'].map((row) => List<int>.from(row))),
      companyId: json['company_id'],
      branchId: json['branch_id'],
      isActive: json['is_active'] ?? true,
      isReserved: json['is_reserved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board_id': boardId,
      'board_name': boardName,
      'board_numbers': boardNumbers,
      'company_id': companyId,
      'branch_id': branchId,
      'is_active': isActive,
      'is_reserved': isReserved,
    };
  }
}
