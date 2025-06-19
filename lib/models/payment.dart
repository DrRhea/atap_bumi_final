class Payment {
  final int id;
  final int rentalId;
  final String paymentMethod;
  final double totalRentalCost;
  final double shippingCost;
  final double depositPaid;
  final double totalPaid;
  final String paymentStatus;
  final DateTime? paymentDate;
  final String? paymentProof;
  final String? paymentReferenceCode;
  final String? paymentNotes;

  Payment({
    required this.id,
    required this.rentalId,
    required this.paymentMethod,
    required this.totalRentalCost,
    required this.shippingCost,
    required this.depositPaid,
    required this.totalPaid,
    required this.paymentStatus,
    this.paymentDate,
    this.paymentProof,
    this.paymentReferenceCode,
    this.paymentNotes,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'],
    rentalId: json['rental_id'],
    paymentMethod: json['payment_method'],
    totalRentalCost: double.parse(json['total_rental_cost'].toString()),
    shippingCost: double.parse(json['shipping_cost'].toString()),
    depositPaid: double.parse(json['deposit_paid'].toString()),
    totalPaid: double.parse(json['total_paid'].toString()),
    paymentStatus: json['payment_status'],
    paymentDate:
        json['payment_date'] != null
            ? DateTime.parse(json['payment_date'])
            : null,
    paymentProof: json['payment_proof'],
    paymentReferenceCode: json['payment_reference_code'],
    paymentNotes: json['payment_notes'],
  );

  Map<String, dynamic> toJson() => {
    'rental_id': rentalId,
    'payment_method': paymentMethod,
  };

  bool get isPaid => paymentStatus == 'paid';
  bool get isPending => paymentStatus == 'pending';
  double get totalAmount => totalRentalCost + shippingCost + depositPaid;
}
