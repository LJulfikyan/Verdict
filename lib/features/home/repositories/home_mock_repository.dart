import '../../../data/models/case_model.dart';

class HomeMockRepository {
  static const int pageSize = 5;

  Future<List<CaseModel>> fetchFeed({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final start = page * pageSize;
    if (start >= _mockCases.length) {
      return const [];
    }

    final end = (start + pageSize).clamp(0, _mockCases.length);
    return _mockCases.sublist(start, end);
  }
}

final List<CaseModel> _mockCases = [
  CaseModel(
    id: 'case_1',
    authorId: 'u_1',
    relationshipType: 'Wife',
    category: 'Money',
    description:
        'My wife and I agreed to keep big purchases above \$500 as a joint decision. I bought a new gaming monitor for work and hobbies because mine broke, but I told her after it arrived. She says I ignored the agreement and acted single. I think replacing broken equipment was reasonable and urgent.',
    question: 'Was I wrong for buying it first and explaining later?',
    status: 'active',
    votesCount: 1426,
    reportsCount: 0,
    results: const {
      'youRight': 51,
      'theyRight': 29,
      'bothWrong': 12,
      'needInfo': 8,
    },
    hotScore: 98.2,
    createdAt: DateTime(2026, 6, 4, 10, 15),
  ),
  CaseModel(
    id: 'case_2',
    authorId: 'u_2',
    relationshipType: 'Boyfriend',
    category: 'Friends',
    description:
        'My boyfriend got upset because I went to dinner with a longtime male friend from college. I told him ahead of time, shared where we were going, and even invited him, but he said the whole thing was disrespectful because the friend used to have a crush on me years ago.',
    question: 'Was I wrong for going anyway?',
    status: 'active',
    votesCount: 918,
    reportsCount: 0,
    results: const {
      'youRight': 63,
      'theyRight': 18,
      'bothWrong': 11,
      'needInfo': 8,
    },
    hotScore: 94.8,
    createdAt: DateTime(2026, 6, 4, 8, 5),
  ),
  CaseModel(
    id: 'case_3',
    authorId: 'u_3',
    relationshipType: 'Partner',
    category: 'Travel',
    description:
        'My partner wanted us to spend our only week off visiting their family. I wanted a quiet trip alone together because the last three vacations were family-related. I booked a refundable cabin before we fully settled it, and now they feel like I manipulated the decision.',
    question: 'Was I wrong for booking something before we fully agreed?',
    status: 'active',
    votesCount: 603,
    reportsCount: 0,
    results: const {
      'youRight': 34,
      'theyRight': 38,
      'bothWrong': 20,
      'needInfo': 8,
    },
    hotScore: 89.3,
    createdAt: DateTime(2026, 6, 3, 23, 40),
  ),
  CaseModel(
    id: 'case_4',
    authorId: 'u_4',
    relationshipType: 'Girlfriend',
    category: 'Social Media',
    description:
        'My girlfriend posts everything online and recently uploaded a video of us arguing in the car, with the audio muted and a caption making it look funny. I asked her to remove it because I felt exposed, but she says nobody knows the context and I am being dramatic.',
    question: 'Was I wrong for insisting she delete it?',
    status: 'active',
    votesCount: 2104,
    reportsCount: 0,
    results: const {
      'youRight': 72,
      'theyRight': 9,
      'bothWrong': 14,
      'needInfo': 5,
    },
    hotScore: 97.1,
    createdAt: DateTime(2026, 6, 3, 19, 12),
  ),
  CaseModel(
    id: 'case_5',
    authorId: 'u_5',
    relationshipType: 'Husband',
    category: 'Family',
    description:
        'My husband keeps volunteering me to host family dinners without asking first. This weekend I said no because I had work deadlines and wanted a quiet Sunday. He told his parents I was tired, but later said I embarrassed him by making him cancel at the last minute.',
    question: 'Was I wrong for refusing to host?',
    status: 'active',
    votesCount: 487,
    reportsCount: 0,
    results: const {
      'youRight': 58,
      'theyRight': 17,
      'bothWrong': 17,
      'needInfo': 8,
    },
    hotScore: 82.4,
    createdAt: DateTime(2026, 6, 3, 17, 50),
  ),
  CaseModel(
    id: 'case_6',
    authorId: 'u_6',
    relationshipType: 'Fiancee',
    category: 'Communication',
    description:
        'My fiancee says I shut down during difficult talks. Last night after a long workday, she brought up wedding budget issues and I asked to discuss it tomorrow. She says postponing serious conversations is exactly the problem and that I prioritize comfort over partnership.',
    question: 'Was I wrong for asking to wait until the next day?',
    status: 'active',
    votesCount: 756,
    reportsCount: 0,
    results: const {
      'youRight': 27,
      'theyRight': 46,
      'bothWrong': 19,
      'needInfo': 8,
    },
    hotScore: 86.0,
    createdAt: DateTime(2026, 6, 3, 15, 20),
  ),
  CaseModel(
    id: 'case_7',
    authorId: 'u_7',
    relationshipType: 'Partner',
    category: 'Household',
    description:
        'We both work full time, but I usually end up doing the deeper cleaning before guests come over. This time I cleaned the whole apartment and got annoyed when my partner said they had "helped by staying out of the way." I snapped and now they think I made chores into a competition.',
    question: 'Was I wrong for snapping about the cleaning?',
    status: 'active',
    votesCount: 1332,
    reportsCount: 0,
    results: const {
      'youRight': 43,
      'theyRight': 24,
      'bothWrong': 25,
      'needInfo': 8,
    },
    hotScore: 91.5,
    createdAt: DateTime(2026, 6, 3, 12, 8),
  ),
  CaseModel(
    id: 'case_8',
    authorId: 'u_8',
    relationshipType: 'Boyfriend',
    category: 'Jealousy',
    description:
        'My boyfriend asked to see my phone after noticing I still text an ex occasionally about our shared dog. I refused because I think privacy matters, and now he says refusing proves I care more about hiding things than building trust. The messages are genuinely only about the dog.',
    question: 'Was I wrong for refusing to hand over my phone?',
    status: 'active',
    votesCount: 1678,
    reportsCount: 0,
    results: const {
      'youRight': 49,
      'theyRight': 22,
      'bothWrong': 21,
      'needInfo': 8,
    },
    hotScore: 93.0,
    createdAt: DateTime(2026, 6, 3, 9, 45),
  ),
];
