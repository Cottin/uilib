

export default staticStyles = "
	.spinner-jumpingBalls, .spinner-jumpingBalls:before, .spinner-jumpingBalls:after {
		border-radius: 50%;
		width: 2.5em;
		height: 2.5em;
		animation-fill-mode: both;
		animation: ani-spinner-jumpingBalls 1.8s infinite ease-in-out;
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

	@keyframes ani-spinner-jumpingBalls {
		0%, 80%, 100% { box-shadow: 0 2.5em 0 -1.3em }
		40% { box-shadow: 0 2.5em 0 0 }
	}


	.spinner-pulse {
		width: 48px;
		height: 48px;
		display: inline-block;
		position: relative;
	}
	.spinner-pulse::after,
	.spinner-pulse::before {
		content: '';  
		box-sizing: border-box;
		width: 48px;
		height: 48px;
		border-radius: 50%;
		background: #FFF;
		position: absolute;
		left: 0;
		top: 0;
		animation: ani-spinner-pulse 2s linear infinite;
	}
	.spinner-pulse::after {
		animation-delay: 1s;
	}

	@keyframes ani-spinner-pulse {
		0% {
			transform: scale(0);
			opacity: 1;
		}
		100% {
			transform: scale(1);
			opacity: 0;
		}
	}
			

.loader {
	width: 48px;
	height: 48px;
	display: inline-block;
	position: relative;
}
.loader::after,
.loader::before {
	content: '';  
	box-sizing: border-box;
	width: 48px;
	height: 48px;
	border-radius: 50%;
	background: #FFF;
	position: absolute;
	left: 0;
	top: 0;
	animation: animloader 2s linear infinite;
}
.loader::after {
	animation-delay: 1s;
}

@keyframes animloader {
	0% {
		transform: scale(0);
		opacity: 1;
	}
	100% {
		transform: scale(1);
		opacity: 0;
	}
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



	/* CHECKMARK - Adapted from https://stackoverflow.com/a/41078668/416797 ----------------------------- */
	.checkmark {
		border-radius: 50%;
		display: block;
		stroke-width: 6;
		stroke-linecap: round;
		stroke-linejoin: round;
	}

	.checkmark__check {
		transform-origin: 50% 50%;
		stroke-dasharray: 98; /* Adjust speed of checkmar drawing by changing these two values */
		stroke-dashoffset: 98;
		animation: aniCheckStroke 0.5s cubic-bezier(0.65, 0, 0.45, 1) 0s forwards, aniCheckScale2 .5s ease-in-out 0s both;
	}

	.spinnerScale {
		animation: aniCheckScale .3s ease-in-out 0s both;
	}

	@keyframes aniCheckStroke {
		100% {
			stroke-dashoffset: 0;
		}
	}
	@keyframes aniCheckScale {
		0%, 100% {
			transform: none;
		}
		50% {
			transform: scale3d(1.1, 1.1, 1);
		}
	}
	@keyframes aniCheckScale2 {
		0%, 100% {
			transform: none;
		}
		50% {
			transform: scale3d(1.3, 1.3, 1);
		}
	}


	/* SPINNER - Adapded from Postnord https://account.postnord.com/public/login ----------------------- */
	.spinnerSvg {
    transition: transform 0.2s cubic-bezier(0.7, 0, 0.3, 1) 0.3s,
    	-webkit-transform 0.2s cubic-bezier(0.7, 0, 0.3, 1) 0.3s;
	    animation: 1s cubic-bezier(0.5, 0, 0.5, 1) 0s infinite normal none running aniSpinnerRotate;
	}

	.spinnerStroke {
    animation: 2s cubic-bezier(0.5, 0, 0.5, 1) 0s infinite normal none running aniSpinnerStroke;
    stroke-dasharray: 64;
    stroke-linecap: round;
    stroke-linejoin: round;
    transform: rotate(-310deg);
    transform-origin: center center;
	}

	.spinnerShrink {
		animation: aniSpinnerShrink 2s ease-in 0.2s 1 normal forwards;
	}

	@keyframes aniSpinnerStroke {
		0% {
			stroke-dashoffset: 55;
		}
		50% {
			stroke-dashoffset: 12;
		}
		100% {
			stroke-dashoffset: 55;
		}
	}

	@keyframes aniSpinnerRotate {
	  0% {
	    transform: rotate(-180deg) scaleX(-1);
	  }

	  100% {
	    transform: rotate(180deg) scaleX(-1);
	  }
	}

	@keyframes aniSpinnerShrink {
	  0% {
	  	width: 100%;
	    border-radius: 0;
	  }

	  100% {
	  	width: 20%;
	    border-radius: 50%;
	  }
	}

	.spinnerBg {
		transition: min-width 0.8s cubic-bezier(0.7, 0, 0.3, 1),
								border-radius 0.6s cubic-bezier(0.7, 0, 0.3, 1) 0.2s,
								background-color 0.15s ease,
								outline 0.15s ease;
	}
	/* ------------------------------------------------------------------------------------------------- */

	.flipperBase {
		width: 300%;
		margin-left: -100%;
		display: flex;
		flex-direction: row;
		flex-grow: 1;
	}

"
