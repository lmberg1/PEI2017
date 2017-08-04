ampRot = [[30  35  56]; [29  22  44]; [60  11  21]];
varRot = [[175  34  23]; [196  31   22]; [146  26  20]];
var = [[133  18   6]; [118  35  24]; [146  26  20]];
x = 1:3;

figure;
subplot(3, 1, 1)
hold on;
bar((x - 0.125), var(1, :), 0.125, 'b', 'FaceAlpha', 0.5);
bar(x, var(2, :), 0.125, 'g', 'FaceAlpha', 0.5);
bar((x + 0.125), var(3, :), 0.125, 'm', 'FaceAlpha', 0.5);
legend(["X Comp" "Y Comp" "Z Comp"]);
ylim([0 200]);
xlim([0.75 3.25]);
xticks([1 2 3]);
xticklabels(["0.01-0.10" "0.10-1.00" "0.50-2.00"]);
xlabel("Frequency Band (hz)");
ylabel("Number of Visible Events");
title("Variance Based SNR, Unrotated");
hold off;

subplot(3, 1, 2)
hold on;
bar((x - 0.125), varRot(1, :), 0.125, 'b', 'FaceAlpha', 0.5);
bar(x, varRot(2, :), 0.125, 'g', 'FaceAlpha', 0.5);
bar((x + 0.125), varRot(3, :), 0.125, 'm', 'FaceAlpha', 0.5);
legend(["X Comp" "Y Comp" "Z Comp"]);
ylim([0 200]);
xlim([0.75 3.25]);
xticks([1 2 3]);
xticklabels(["0.01-0.10" "0.10-1.00" "0.50-2.00"]);
xlabel("Frequency Band (hz)");
ylabel("Number of Visible Events");
title("Variance Based SNR, Rotated");
hold off;

subplot(3, 1, 3)
hold on;
bar((x - 0.125), ampRot(1, :), 0.125, 'b', 'FaceAlpha', 0.5);
bar(x, ampRot(2, :), 0.125, 'g', 'FaceAlpha', 0.5);
bar((x + 0.125), ampRot(3, :), 0.125, 'm', 'FaceAlpha', 0.5);
legend(["X Comp" "Y Comp" "Z Comp"]);
ylim([0 200]);
xlim([0.75 3.25]);
xticks([1 2 3]);
xticklabels(["0.01-0.10" "0.10-1.00" "0.50-2.00"]);
xlabel("Frequency Band (hz)");
ylabel("Number of Visible Events");
title("Amplitude Based SNR, Rotated");
hold off;