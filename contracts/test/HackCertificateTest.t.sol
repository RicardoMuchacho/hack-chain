// License
// SPDX-License-Identifier: MIT

// Compiler Solidity version
pragma solidity ^0.8.24;

// Libreries
import "forge-std/Test.sol";
import "../src/HackCertificate.sol";

// Contract
contract HackCertificateTest is Test {
    
    // Variables
    HackCertificate hackCertificate;
    address public admin = vm.addr(1);
    address public randomUser = vm.addr(2);
    address public authorizedIssuer = vm.addr(3);
    address public unauthorizedIssuer = vm.addr(4);
    address public randomStudent = vm.addr(5);
    address public randomStudent2 = vm.addr(6);

    // Functions
    function setUp() public {
        vm.startPrank(admin);
        hackCertificate = new HackCertificate();
        hackCertificate.authorizeIssuer(authorizedIssuer);
        vm.stopPrank();
        assertEq(hackCertificate.owner(), admin);
    }

<<<<<<< HEAD
    /**
     * Used to prevent a non-administrator from giving another user permission to issue certificates.
     */
=======
    // --- Owner functions (authorize/revoke issuers) ---
    
    function testShouldOnlyAllowOwnerToAuthorizeIssuer() public {
        vm.startPrank(admin);
        hackCertificate.authorizeIssuer(unauthorizedIssuer);
        vm.stopPrank();
        assertEq(hackCertificate.authorizedIssuers(unauthorizedIssuer), true);
    }
>>>>>>> 28b0824 (Fix tests and increase coverage)

    function testShouldNotAllowToAuthorizeIfNotAdmin() public {
        vm.startPrank(randomUser);
        vm.expectRevert();
        hackCertificate.authorizeIssuer(unauthorizedIssuer);
        vm.stopPrank();
    }

<<<<<<< HEAD
    /**
     * Used to verify that an authorized educator can correctly issue a certificate.
     */
=======
    function testShouldOnlyAllowOwnerToRevokeIssuer() public {
        vm.startPrank(admin);
        hackCertificate.revokeIssuer(authorizedIssuer);
        vm.stopPrank();
        assertEq(hackCertificate.authorizedIssuers(authorizedIssuer), false);
    }

    function testOnlyAdminCanRevokeIssuers() public {
        vm.expectRevert();
        hackCertificate.revokeIssuer(authorizedIssuer);
    }

    // --- Issue Certificate ---
>>>>>>> 28b0824 (Fix tests and increase coverage)

    function testShouldAllowToIssueCertificate() public {
        vm.startPrank(authorizedIssuer);
        uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Pentesting");
        uint256 tokenId2 = hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Quality Assurance");
        vm.stopPrank();
        assertEq(1, tokenId1);
        assertEq(2, tokenId2);
    }
    
    /**
     * Used to prevent an unauthorized educator from issuing a certificate
     */

    function testShouldNotAllowToIssueCertificateIfNotAuthorized() public {
        vm.startPrank(unauthorizedIssuer);
        vm.expectRevert("Not authorized issuer");
        hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Pentesting");
        vm.stopPrank();
    }

<<<<<<< HEAD
    /**
     * Used to verify that the issued certificate is correctly stored in the blockchain
     */
=======
    function testRevokedIssuerCannotMintAnymore() public {
        vm.startPrank(admin);
        hackCertificate.revokeIssuer(authorizedIssuer);
        vm.stopPrank();

        vm.startPrank(authorizedIssuer);
        vm.expectRevert("Not authorized issuer");
        hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Pentesting");
        vm.stopPrank();
    }

    // --- Verify Certificate ---
>>>>>>> 28b0824 (Fix tests and increase coverage)

    function testShouldVerifyCertificate() public {
        vm.startPrank(authorizedIssuer);
        uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Pentesting");
        vm.stopPrank();
        assertEq(1, tokenId1);

        HackCertificate.Certificate memory c = hackCertificate.verifyCertificate(tokenId1);
        assertEq(c.courseName, "Pentesting");
        assertEq(c.issuedAt, block.timestamp);
        assertEq(c.issuer, authorizedIssuer);
        assertEq(c.studentName, "Ramdonlito");
    }

    /**
     * Used to verify that the contract reverts in case the certificate does not exist
     */

    function testShouldRevertIfCertificateDoesNotExist() public {
        vm.expectRevert();
        hackCertificate.verifyCertificate(0);
    }

<<<<<<< HEAD
    /**
     * Used to prevent a revoked educator from issuing a certificate
     */

    function testRevokedIssuerCannotMintAnymore() public {
        vm.startPrank(admin);
        hackCertificate.revokeIssuer(authorizedIssuer);
=======
    // --- Revoke Certificate ---

    function testShouldRevokeCertificate() public {
>>>>>>> 28b0824 (Fix tests and increase coverage)
        vm.startPrank(authorizedIssuer);
        uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Juan", "Solidity");
        vm.stopPrank();
        assertEq(tokenId1, 1);

        vm.startPrank(authorizedIssuer);
        hackCertificate.revokeCertificate(tokenId1);
        vm.stopPrank();
    }

<<<<<<< HEAD
    /**
     * Used to verify that only the admin can revoke an educator
     */

    function testOnlyAdminCanRevokedIssuers() public {
        vm.expectRevert();
        hackCertificate.revokeIssuer(authorizedIssuer);
    }

    /**
     * Used to verify that the certificate is revoked correctly
     */

    function testShouldRevokeCertificate() public {
   
    vm.startPrank(authorizedIssuer);
    uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Juan", "Solidity");
    vm.stopPrank();
    assertEq(tokenId1, 1);

    
    vm.startPrank(authorizedIssuer);
    hackCertificate.revokeCertificate(tokenId1);
    vm.stopPrank();

    
    vm.expectRevert("Certificate does not exist");
    hackCertificate.verifyCertificate(tokenId1);
}

    /**
     * Used to verify that the certificate is not revoked if the educator is not authorized
     */

    function testShouldNotRevokeCertificate() public {
   
    vm.startPrank(authorizedIssuer);
    uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Juan", "Solidity");
    vm.stopPrank();
    assertEq(tokenId1, 1);

    
    vm.startPrank(unauthorizedIssuer);
    
    vm.expectRevert();
    hackCertificate.revokeCertificate(tokenId1);
    vm.stopPrank();

}

    /**
     * Used to verify that the student cannot transfer their certificate
     */

    function testStudentCanNotTransferHisCertificate() public {
        vm.startPrank(authorizedIssuer);
        uint256 tokenId1 = hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Pentesting");
        uint256 tokenId2 = hackCertificate.issueCertificate(randomStudent, "Ramdonlito", "Quality Assurance");
        vm.stopPrank();
        assertEq(1, tokenId1);
        assertEq(2, tokenId2);

        vm.startPrank(randomStudent);
        vm.expectRevert();
        hackCertificate.transferFrom(msg.sender, randomStudent2, tokenId1);
        vm.stopPrank();  

        vm.startPrank(randomStudent);
        vm.expectRevert();
        hackCertificate.safeTransferFrom(msg.sender, randomStudent2, tokenId2);
        vm.stopPrank();   

        vm.startPrank(randomStudent);
        vm.expectRevert();
        hackCertificate.safeTransferFrom(msg.sender, randomStudent2, tokenId2, bytes("Test"));
        vm.stopPrank();          

    }   

}
=======
    function testRevokeCertificateUnauthorizedFails() public {
        vm.startPrank(authorizedIssuer);
        uint256 tokenId = hackCertificate.issueCertificate(randomStudent, "Juan", "Solidity");
        vm.stopPrank();

        vm.startPrank(randomUser); // ni owner ni issuer
        vm.expectRevert("Not authorized to revoke");
        hackCertificate.revokeCertificate(tokenId);
        vm.stopPrank();
    }

    function testRevokeNonExistentCertificateFails() public {
        vm.startPrank(admin);
        vm.expectRevert();
        hackCertificate.revokeCertificate(999);
        vm.stopPrank();
    }
}
>>>>>>> 28b0824 (Fix tests and increase coverage)
