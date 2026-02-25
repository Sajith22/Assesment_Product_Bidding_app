enum AuctionStatus { live, upcoming, ended }

class Product {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final double startPrice;
  final double? currentBid;
  final int bidCount;
  final AuctionStatus status;
  final String endTime;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.startPrice,
    this.currentBid,
    required this.bidCount,
    required this.status,
    required this.endTime,
  });
}

class BidEntry {
  final int rank;
  final String bidderName;
  final String timeAgo;
  final double amount;
  final bool isWinner;

  const BidEntry({
    required this.rank,
    required this.bidderName,
    required this.timeAgo,
    required this.amount,
    this.isWinner = false,
  });
}

// Sample data
final List<Product> sampleProducts = [
  Product(
    id: '1',
    title: 'Wireless Headphones',
    category: 'Electronics',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100&h=100&fit=crop',
    startPrice: 150,
    currentBid: 285,
    bidCount: 24,
    status: AuctionStatus.live,
    endTime: '2h 15m',
  ),
  Product(
    id: '2',
    title: 'Smart Watch Pro',
    category: 'Wearables',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=100&h=100&fit=crop',
    startPrice: 200,
    currentBid: null,
    bidCount: 0,
    status: AuctionStatus.upcoming,
    endTime: 'Starts in 6h',
  ),
  Product(
    id: '3',
    title: 'Designer Sunglasses',
    category: 'Fashion',
    imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=100&h=100&fit=crop',
    startPrice: 80,
    currentBid: 165,
    bidCount: 18,
    status: AuctionStatus.ended,
    endTime: 'Ended',
  ),
];

final List<BidEntry> sampleBids = [
  BidEntry(rank: 1, bidderName: 'John Doe', timeAgo: '2 hours ago', amount: 285, isWinner: true),
  BidEntry(rank: 2, bidderName: 'Sarah Smith', timeAgo: '2 hours ago', amount: 280),
  BidEntry(rank: 3, bidderName: 'Mike Johnson', timeAgo: '3 hours ago', amount: 275),
  BidEntry(rank: 4, bidderName: 'Emily Davis', timeAgo: '3 hours ago', amount: 265),
  BidEntry(rank: 5, bidderName: 'Chris Lee', timeAgo: '4 hours ago', amount: 255),
];
