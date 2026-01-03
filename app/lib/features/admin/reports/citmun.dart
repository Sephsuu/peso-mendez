import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/report_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';

class CitmunChart extends HookWidget {
  const CitmunChart({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final data = useState<List<Map<String, dynamic>>>([]);
    final selectedTab = useState("table");

    // Fetch CITMUN counts
    useEffect(() {
      () async {
        try {
          final res = await ReportService.getCitmunCounts();
          data.value = res;
        } catch (e) {
          debugPrint("Citmun Chart Error: $e");
        } finally {
          loading.value = false;
        }
      }();
      return null;
    }, []);

    if (loading.value) return const Loader();
    if (data.value.isEmpty) {
      return const Center(child: Text("No CITMUN data available"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------
        // HEADER
        // ---------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "City/Municipality Distribution",
            style: AppText.textLg.merge(AppText.fontSemibold),
          ),
        ),

        // ---------------------------
        // TABS
        // ---------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              _TabButton(
                label: "Table",
                selected: selectedTab.value == "table",
                onTap: () => selectedTab.value = "table",
              ),
              const SizedBox(width: 10),
              _TabButton(
                label: "Graph",
                selected: selectedTab.value == "graph",
                onTap: () => selectedTab.value = "graph",
              ),
              const SizedBox(width: 30),
              AppButton(
                label: "Export PDF",
                onPressed: () {
                  final rows = PdfExporter.mapToRowList(
                    data: data.value,
                    keys: ["citmun", "total"],
                  );

                  PdfExporter.exportTable(
                    title: "City/Municipality Report",
                    headers: ["City/Municipality", "Total Count"],
                    rows: rows,
                  );
                },
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ---------------------------
        // TABLE VIEW
        // ---------------------------
        if (selectedTab.value == "table")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _CitmunTable(data: data.value),
          ),

        // ---------------------------
        // GRAPH VIEW
        // ---------------------------
        if (selectedTab.value == "graph")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              height: 350,
              child: Scrollbar(
                thumbVisibility: true, 
                thickness: 8,
                radius: const Radius.circular(8),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: scrollableTablePadding),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: data.value.length * 120,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(data.value.length, (i) {
                          final total = data.value[i]["total"];
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: total.toDouble(),
                                width: 30,
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 80,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index < 0 || index >= data.value.length) {
                                  return const SizedBox();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      data.value[index]["citmun"],
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

//
//=====================================================
// 🔹 CITMUN TABLE (Scrollable)
//=====================================================
//
class _CitmunTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _CitmunTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // enable horizontal scrolling
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 215, 215, 215),
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        child: DataTable(
          columnSpacing: 30,
          headingRowHeight: 40,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 40,
          border: TableBorder.all(
            color: const Color.fromARGB(255, 180, 180, 180),
            width: 1,
          ),
          columns: const [
            DataColumn(label: Text("#")),
            DataColumn(label: Text("CITMUN Type")),
            DataColumn(label: Text("Total Count")),
          ],
          rows: data.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;

            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(row["citmun"] ?? "N/A")),
                DataCell(Text(row["total"].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

//
//=====================================================
// 🔹 Modern Tab Button
//=====================================================
//
class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onTap,
      disableShadow: true,
      backgroundColor: Colors.transparent,
      foregroundColor: selected ? AppColor.primary : AppColor.muted,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
