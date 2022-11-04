

export default staticStyles = "
	.spinner-jumpingBalls, .spinner-jumpingBalls:before, .spinner-jumpingBalls:after {
		border-radius: 50%;
		width: 2.5em;
		height: 2.5em;
		animation-fill-mode: both;
		animation: bblFadInOut 1.8s infinite ease-in-out;
	}
	.spinner-jumpingBalls {
		font-size: 7px;
		position: relative;
		text-indent: -9999em;
		transform: translateZ(0);
		animation-delay: -0.16s;
	}
	.spinner-jumpingBalls:before,
	.spinner-jumpingBalls:after {
		content: '';
		position: absolute;
		top: 0;
	}
	.spinner-jumpingBalls:before {
		left: -3.5em;
		animation-delay: -0.32s;
	}
	.spinner-jumpingBalls:after {
		left: 3.5em;
	}

	@keyframes bblFadInOut {
		0%, 80%, 100% { box-shadow: 0 2.5em 0 -1.3em }
		40% { box-shadow: 0 2.5em 0 0 }
	}

	
	.aniModal-enter {
		opacity: 0;
		transform: scale(0.9);
	}
	.aniModal-enter-active {
		opacity: 1;
		transform: translateX(0);
		transition: opacity 300ms, transform 300ms;
	}
	.aniModal-exit {
		opacity: 1;
	}
	.aniModal-exit-active {
		opacity: 0;
		transform: scale(0.9);
		transition: opacity 300ms, transform 300ms;
	}

	.aniModal-enter + .backdrop {
		opacity: 0;
	}
	.aniModal-enter-active + .backdrop {
		opacity: 1;
		transition: opacity 300ms;
	}
	.aniModal-exit + .backdrop {
		opacity: 1;
	}
	.aniModal-exit-active + .backdrop {
		opacity: 0;
		transition: opacity 300ms;
	}

"
