import 'package:flutter/material.dart';

class Tos extends StatelessWidget {
  const Tos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms Of Service"),
      ),
      body: const SingleChildScrollView(
        child: Text(
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey,
            ),
            'Website Terms and Conditions of Use\nTerms By accessing this Website, accessible from chat.samueldoes.dev, you are agreeing to be bound by these Website Terms and Conditions of Use and agree that you are responsible for the agreement with any applicable local laws. If you disagree with any of these terms, you are prohibited from accessing this site. The materials contained in this Website are protected by copyright and trade mark law.\nUse License Permission is granted to temporarily download one copy of the materials on Ballbert LLCs Website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\nmodify or copy the materials; use the materials for any commercial purpose or for any public display; attempt to reverse engineer any software contained on Ballbert LLCs Website; remove any copyright or other proprietary notations from the materials; or transferring the materials to another person or "mirror" the materials on any other server. This will let Ballbert LLC to terminate upon violations of any of these restrictions. Upon termination, your viewing right will also be terminated and you should destroy any downloaded materials in your possession whether it is printed or electronic format. These Terms of Service has been created with the help of the Terms Of Service Generator.\nDisclaimer All the materials on Ballbert LLC’s Website are provided "as is". Ballbert LLC makes no warranties, may it be expressed or implied, therefore negates all other warranties. Furthermore, Ballbert LLC does not make any representations concerning the accuracy or reliability of the use of the materials on its Website or otherwise relating to such materials or any sites linked to this Website.\nLimitations Ballbert LLC or its suppliers will not be hold accountable for any damages that will arise with the use or inability to use the materials on Ballbert LLC’s Website, even if Ballbert LLC or an authorize representative of this Website has been notified, orally or written, of the possibility of such damage. Some jurisdiction does not allow limitations on implied warranties or limitations of liability for incidental damages, these limitations may not apply to you.\nRevisions and Errata The materials appearing on Ballbert LLC’s Website may include technical, typographical, or photographic errors. Ballbert LLC will not promise that any of the materials in this Website are accurate, complete, or current. Ballbert LLC may change the materials contained on its Website at any time without notice. Ballbert LLC does not make any commitment to update the materials.\nLinks Ballbert LLC has not reviewed all of the sites linked to its Website and is not responsible for the contents of any such linked site. The presence of any link does not imply endorsement by Ballbert LLC of the site. The use of any linked website is at the user’s own risk.\nSite Terms of Use Modifications Ballbert LLC may revise these Terms of Use for its Website at any time without prior notice. By using this Website, you are agreeing to be bound by the current version of these Terms and Conditions of Use.\nYour Privacy Please read our Privacy Policy.\nGoverning Law Any claim related to Ballbert LLCs Website shall be governed by the laws of us without regards to its conflict of law provisions.'),
      ),
    );
  }
}
