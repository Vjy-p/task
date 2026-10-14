import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class AnimatedOrderTracker extends StatelessWidget {
  final OrderModel order;

  const AnimatedOrderTracker({super.key, required this.order});

  static const statuses = OrderStatus.values;

  int get currentIndex => order.status.index;

  List<DateTime?> get dates => [
    order.createdAt,
    order.confirmedAt,
    order.dispatchedAt,
    order.outForDeliveredAt,
    order.deliveredAt,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < statuses.length; index++)
          _OrderStep(
            status: statuses[index],
            index: index,
            currentIndex: currentIndex,
            date: dates[index],
            isLast: index == statuses.length - 1,
          ),
      ],
    );
  }
}

class _OrderStep extends StatefulWidget {
  final OrderStatus status;
  final int index;
  final int currentIndex;
  final bool isLast;
  final DateTime? date;

  const _OrderStep({
    required this.status,
    required this.index,
    required this.currentIndex,
    required this.isLast,
    this.date,
  });

  @override
  State<_OrderStep> createState() => _OrderStepState();
}

class _OrderStepState extends State<_OrderStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _OrderStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (isCurrent && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!isCurrent && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  bool get isCompleted => widget.index < widget.currentIndex;

  bool get isCurrent => widget.index == widget.currentIndex;

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        progressBarWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 14, bottom: 10),
            child:
                AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? CustomColors.primaryColor.withValues(alpha: 0.08)
                            : CustomColors.whiteColor.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrent
                              ? CustomColors.primaryColor.withValues(
                                  alpha: 0.25,
                                )
                              : CustomColors.whiteColor.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: isCompleted || isCurrent
                                        ? CustomColors.textColor
                                        : CustomColors.textColor.withValues(
                                            alpha: 0.45,
                                          ),
                                    fontSize: 15,
                                    fontWeight: isCurrent
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                  child: Text(widget.status.title),
                                ),
                                const SizedBox(height: 5),
                                if (widget.date != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      DateFormat("dd MMM yyyy  hh:mm:ss a")
                                          .format(widget.date!),
                                      style: TextStyle(
                                        color: CustomColors.blackColor,
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                                Text(
                                  widget.status.description,
                                  style: TextStyle(
                                    color: CustomColors.blackColor,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: widget.index * 100))
                    .fade(duration: const Duration(milliseconds: 500))
                    .slideY(duration: const Duration(milliseconds: 500)),
          ),
        ),
      ],
    );
  }

  Widget progressBarWidget() {
    return SizedBox(
      width: 52,
      child: Column(
        children: [_buildIndicator(), if (!widget.isLast) _buildConnector()],
      ),
    );
  }

  Widget _buildIndicator() {
    return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulse = isCurrent ? 1 + (_pulseController.value * 0.12) : 1.0;

            return Transform.scale(
              scale: pulse,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isCurrent
                      ? CustomColors.lightColor
                      : CustomColors.greyColor.withValues(alpha: 0.5),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: CustomColors.primaryColor.withValues(
                              alpha: 0.15 + (_pulseController.value * 0.15),
                            ),
                            blurRadius: 18,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                  border: Border.all(
                    color: isCompleted || isCurrent
                        ? CustomColors.primaryColor.withValues(alpha: 0.8)
                        : CustomColors.whiteColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : widget.status.icon,
                  size: 21,
                  color: isCompleted || isCurrent
                      ? CustomColors.primaryColor
                      : CustomColors.whiteColor.withValues(alpha: 0.35),
                ),
              ),
            );
          },
        )
        .animate(delay: Duration(milliseconds: widget.index * 100))
        .slideY(
          begin: -0.5 * widget.index,
          end: 0,
          duration: const Duration(milliseconds: 500),
        );
  }

  Widget _buildConnector() {
    final completed = widget.index < widget.currentIndex;

    return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 2,
          height: 62,
          decoration: BoxDecoration(
            color: completed
                ? CustomColors.primaryColor
                : CustomColors.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
            boxShadow: completed
                ? [
                    BoxShadow(
                      color: CustomColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        )
        .animate(delay: Duration(milliseconds: widget.index * 100))
        .slideY(
          begin: -0.5 * widget.index,
          end: 0,
          duration: const Duration(milliseconds: 500),
        );
  }
}
