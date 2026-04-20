# FFT.m

`FFT.m` simulates an ECG-like signal, adds random noise and a 50 Hz interference component, uses the Fast Fourier Transform (FFT) to detect the dominant heart-rate and disturbance frequencies, removes the disturbance in the frequency domain, reconstructs the filtered signal with the inverse FFT, and visualizes the result.

## What the script does

The script creates a synthetic heart signal at 1.2 Hz, corresponding to 72 BPM, and combines it with Gaussian noise and a sinusoidal 50 Hz disturbance. It then computes the FFT of the noisy signal, builds an amplitude spectrum, and searches for the dominant peak in the low-frequency range to estimate the heart frequency.

It also searches around 50 Hz to identify the interference peak. After that, the code removes the disturbance by zeroing a narrow band of FFT coefficients around the 50 Hz component and its mirrored negative-frequency component. The filtered time-domain signal is obtained with the inverse FFT.

## Output

When the script runs, it:

- prints the detected heart frequency in Hz
- prints the detected disturbance frequency in Hz
- prints the estimated heart rate in BPM
- prints the frequency resolution
- opens three figures showing the clean heart signal, the noisy ECG signal, the filtered signal, the amplitude spectrum, and a comparison of noisy versus filtered data
- saves the three figures as `figur1.png`, `figur2.png`, and `figur3.png` on the desktop

## Parameters used

- Sampling frequency: `500 Hz`
- Signal duration: `10 s`
- Number of samples: `5000`
- Heart frequency: `1.2 Hz`
- Interference frequency: `50 Hz`

## Notes

The filtering is implemented as a simple notch in the FFT domain by setting selected frequency bins to zero. This works for the simulated example, but the exact bin indices are hard-coded for the current sampling setup, so they would need to be adjusted if `fs`, `T`, or the target disturbance frequency changes.
