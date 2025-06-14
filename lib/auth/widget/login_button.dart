// import 'package:flutter/material.dart';

// class LoginButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback onPressed;

//   const LoginButton({
//     Key? key,
//     required this.isLoading,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child:
//             isLoading
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
